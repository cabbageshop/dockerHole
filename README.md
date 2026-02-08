# dockerHole

A Tailscale exit node with integrated ad-blocking via Pi-hole.

## How it works

This setup uses a custom Tailscale container that intercepts all DNS traffic (port 53) passing through it when used as an exit node. This traffic is redirected to a Pi-hole instance running in the same network stack.

**Benefit:** Ad-blocking is automatically enabled when you switch to the `docker-hole` exit node on your Tailscale client, and disabled when you switch back to your normal connection. No global DNS changes are required in your Tailscale admin console.

## Setup

1. **Clone the repository:**
   ```bash
   git clone https://github.com/cabbageshop/dockerHole.git
   cd dockerHole
   ```

2. **Configure environment variables:**
   ```bash
   cp .env.example .env
   ```
   - `TS_AUTHKEY`: Generate a reusable auth key from the [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys).
   - `PIHOLE_PASSWORD`: Set a password for the Pi-hole web interface.

3. **Enable IP Forwarding on the host:**

   **Linux:**
   ```bash
   sudo sysctl -w net.ipv4.ip_forward=1
   sudo sysctl -w net.ipv6.conf.all.forwarding=1
   ```

   **macOS:**
   ```bash
   sudo sysctl -w net.inet.ip.forwarding=1
   sudo sysctl -w net.inet6.ip6.forwarding=1
   ```

4. **Start the containers:**
   ```bash
   docker-compose up -d --build
   ```

5. **Enable the Exit Node in Tailscale:**
   - Go to the [Tailscale Machines page](https://login.tailscale.com/admin/machines).
   - Find `docker-hole`.
   - Click **Edit route settings** and enable **Use as exit node**.

## Usage

On your phone or computer, open Tailscale and select **Exit Node** -> **docker-hole**. Your traffic and DNS will now be filtered by Pi-hole.

## Accessing Pi-hole Admin

The Pi-hole web interface is accessible via your Tailscale IP at `http://<tailscale-ip>/admin`.
