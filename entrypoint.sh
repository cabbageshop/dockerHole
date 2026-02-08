#!/bin/sh

# Userspace mode doesn't create a tailscale0 interface, so we skip waiting for it.

# Force local resolution to Pi-hole for the container itself
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# Execute the original Tailscale entrypoint to start the daemon
exec /usr/local/bin/containerboot