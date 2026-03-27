# dockerHole

A Docker container designed to function as a Tailscale exit node with integrated ad-blocking capabilities, similar to Pi-hole.

## Technical Implementation Summary

- **Userspace Networking:** Uses `TS_USERSPACE=true` to bypass kernel-level MTU and fragmentation issues. This ensures that web browsing (TCP) works reliably where standard kernel `tun` devices might fail.
- **Pi-hole v6:** Utilizes the latest Pi-hole v6 environment variables (`FTLCONF_...`) for configuration.
- **IPv4 Preference:** Configured with `FTLCONF_resolver_resolveIPv6=false` and system-level IPv6 disabling (`sysctls`) to prevent DNS-level IPv6 leaks and ensure consistency with the IPv4-focused routing stack.
- **Shared Network Stack (Host Mode):** For maximum reliability on Mac/OrbStack, Tailscale uses `network_mode: host` while Pi-hole links to it via `network_mode: service:tailscale`. This ensures both containers share the same network namespace and have reliable internet access.
- **Bootstrap DNS:** The custom `entrypoint.sh` for Tailscale initially sets `/etc/resolv.conf` to a public DNS (e.g., `1.1.1.1`). This breaks the circular dependency where `tailscaled` needs DNS to authenticate, but the local Pi-hole is not yet ready or reachable.
- **Explicit Hostname:** Tailscale is started with `--hostname=docker-hole` to prevent it from inheriting the host machine's name in `host` network mode and to avoid name collisions in the Tailnet.

## Operational Learnings

- **Auth Keys:** Always use **Reusable** keys for Docker deployments. One-time keys will cause `API key does not exist` errors if the container restarts or re-authenticates.
- **Namespace Sharing:** In some Docker runtimes (OrbStack/Docker Desktop), `network_mode: service:X` can lead to namespace desynchronization if the target container restarts frequently. Ensuring a stable Tailscale connection is key to maintaining the shared stack.
- **Ghost Machines:** If the container IP or registration changes, old "ghost" entries in the Tailscale Admin console must be removed manually to allow the container to reclaim the `docker-hole` name.
