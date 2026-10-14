# Multi-Arch LanCache Builder

Automated GitHub Actions workflow that compiles and publishes official [LanCache.NET](https://lancache.net) container images natively for **`linux/amd64`** and **`linux/arm64`** to GitHub Container Registry (`ghcr.io`).

## Published Multi-Arch Images
- `ghcr.io/opeitsmax/lancache-monolithic:0.2.1` (`amd64`, `arm64`)
- `ghcr.io/opeitsmax/lancache-dns:0.2.1` (`amd64`, `arm64`)

## How to Trigger Build
1. Push to `main` branch, or
2. Go to **Actions** &rarr; **Build Multi-Arch LanCache Images** &rarr; **Run workflow**.
