# dockerHole

A Docker container designed to function as a Tailscale exit node with integrated ad-blocking capabilities, similar to Pi-hole.

## Technical Implementation Summary

- **Userspace Networking:** Uses `TS_USERSPACE=true` to bypass kernel-level MTU and fragmentation issues. This ensures that web browsing (TCP) works reliably where standard kernel `tun` devices might fail.
- **Pi-hole v6:** Utilizes the latest Pi-hole v6 environment variables (`FTLCONF_...`) for configuration.
- **IPv4 Preference:** Configured with `FTLCONF_resolver_resolveIPv6=false` to prevent DNS-level IPv6 leaks and ensure consistency with the IPv4-focused routing stack.
- **Shared Network Stack:** Pi-hole runs using `network_mode: service:tailscale`, allowing it to listen directly on the Tailscale interface's ports without complex port mapping or additional NAT.
- **Forced Resolver:** The custom `entrypoint.sh` overwrites `/etc/resolv.conf` within the container to ensure all internal processes (including `tailscaled`) utilize the local Pi-hole instance.