#!/bin/bash
set -e

# Support direct CLI invocation (e.g. docker exec -it <container> SteamPrefill select-apps)
if [ "$1" = "SteamPrefill" ] || [ "$1" = "EpicPrefill" ] || [ "$1" = "BattleNetPrefill" ]; then
    exec "$@"
fi

echo "=========================================================="
echo "          LanCache Prefill Service for Umbrel             "
echo "=========================================================="
echo "Binaries available: SteamPrefill, EpicPrefill, BattleNetPrefill"

if [ "${ENABLE_PREFILL}" != "true" ]; then
    echo "Prefill service status: DISABLED"
    echo "To activate automated game pre-caching, set ENABLE_PREFILL=true in your Umbrel LanCache App Settings."
    echo "Standby mode active (0% CPU)."
    exec sleep infinity
fi

echo "Prefill service status: ENABLED"
SCHEDULE="${CRON_SCHEDULE:-0 4 * * *}"
echo "Scheduled prefill time: ${SCHEDULE} (UTC)"

# Script executed on schedule
cat << 'EOF' > /app/run-prefill.sh
#!/bin/bash
echo "[$(date -u)] Starting scheduled prefill run..."

if [ -f "/Config/account.config" ] || [ -f "/Config/Steam/account.config" ]; then
    echo "[$(date -u)] Running SteamPrefill..."
    /app/SteamPrefill prefill --no-ansi || echo "[$(date -u)] SteamPrefill completed with warnings."
else
    echo "[$(date -u)] Notice: SteamPrefill account is not configured yet."
    echo "[$(date -u)] Run 'docker exec -it lancache_prefill_1 SteamPrefill select-apps' in your Umbrel terminal."
fi

if [ -f "/Config/Epic/account.config" ] || [ -f "/Config/Epic/user.config" ]; then
    echo "[$(date -u)] Running EpicPrefill..."
    /app/EpicPrefill prefill --no-ansi || echo "[$(date -u)] EpicPrefill completed with warnings."
fi

if [ -f "/Config/BattleNet/account.config" ] || [ -f "/Config/BattleNet/user.config" ]; then
    echo "[$(date -u)] Running BattleNetPrefill..."
    /app/BattleNetPrefill prefill --no-ansi || echo "[$(date -u)] BattleNetPrefill completed with warnings."
fi

echo "[$(date -u)] Prefill routine completed."
EOF
chmod +x /app/run-prefill.sh

# Register cron job
printenv | grep -E '^(LANCACHE_|PREFILL_|TZ|PATH)' >> /etc/environment || true
echo "${SCHEDULE} root /app/run-prefill.sh >> /proc/1/fd/1 2>&1" > /etc/cron.d/prefill-cron
chmod 0644 /etc/cron.d/prefill-cron

echo "Cron daemon starting in foreground..."
if [ ! -f "/Config/account.config" ] && [ ! -f "/Config/Steam/account.config" ]; then
    echo "----------------------------------------------------------"
    echo "INITIAL SETUP REQUIRED:"
    echo "To authenticate with Steam and choose games to pre-cache,"
    echo "open a terminal on your Umbrel and run:"
    echo "  docker exec -it lancache_prefill_1 SteamPrefill select-apps"
    echo "----------------------------------------------------------"
fi

exec cron -f
