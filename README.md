# dockerHole

A Tailscale exit node with integrated ad-blocking via Pi-hole v6.

## How it works

This setup runs Tailscale in **Userspace Mode** alongside Pi-hole v6 in a shared network namespace. Using Userspace mode avoids complex kernel-level MTU and routing issues common with Docker exit nodes, ensuring stable web browsing.

**Ad-blocking Strategy:** All DNS queries from your Tailnet are routed to the Pi-hole instance. When you use this container as an **Exit Node**, your entire internet traffic is routed through it, benefiting from network-level privacy and filtering.

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
   - `TS_AUTHKEY`: Generate an auth key from the [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys).
   - `PIHOLE_PASSWORD`: Set a password for the Pi-hole web interface.

3. **Start the containers:**
   ```bash
   docker compose up -d --build
   ```

4. **Enable the Exit Node in Tailscale:**
   - Go to the [Tailscale Machines page](https://login.tailscale.com/admin/machines).
   - Find `docker-hole`.
   - Click **Edit route settings** and enable **Use as exit node**.

5. **Configure DNS (Crucial):**
   To ensure all devices use the Pi-hole for ad-blocking:
   - Go to the [Tailscale DNS Console](https://login.tailscale.com/admin/dns).
   - Add a **Custom Nameserver** using the Tailscale IP of your `docker-hole` machine (e.g., `100.x.y.z`).
   - Enable **Override local DNS** to force all Tailscale clients to use this Pi-hole.

## Usage

On your phone or computer, open Tailscale and select **Exit Node** -> **docker-hole**. Your traffic will now be routed through the container, and DNS queries will be filtered by Pi-hole.

## Why Userspace Mode?

Standard kernel-mode exit nodes in Docker often suffer from "MTU Black Holes" where small packets (like Ping) work, but large packets (like Web Pages) fail to load. This project uses Userspace networking to handle packet segmentation internally, providing a much more reliable browsing experience across different networks.

## Troubleshooting

- **Websites not loading:** Ensure **Override local DNS** is enabled in your Tailscale Admin settings. 
- **IPv6 Leaks:** This setup is configured to prefer IPv4 resolution to prevent DNS leaks and routing failures common with IPv6 in containerized environments.
- **Accessing Pi-hole Admin:** Visit `http://<tailscale-ip>/admin`. The login password is what you set in the `.env` file.