#!/bin/sh

# Set DNS to a public one initially to ensure tailscaled can authenticate
# even if Pi-hole is not yet fully ready or unauthenticated.
echo "nameserver 1.1.1.1" > /etc/resolv.conf

# Execute the original Tailscale entrypoint to start the daemon
exec /usr/local/bin/containerboot
