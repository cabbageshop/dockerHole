#!/bin/sh

# Wait for tailscale0 interface to appear
(
    while ! ip addr show tailscale0 >/dev/null 2>&1; do
        sleep 1
    done

    # Intercept all DNS traffic (port 53) coming from Tailscale and redirect to local Pi-hole
    iptables -t nat -A PREROUTING -i tailscale0 -p udp --dport 53 -j REDIRECT --to-ports 53
    iptables -t nat -A PREROUTING -i tailscale0 -p tcp --dport 53 -j REDIRECT --to-ports 53
    
    # Also ensure we allow the traffic to be routed back
    iptables -A INPUT -i tailscale0 -p udp --dport 53 -j ACCEPT
    iptables -A INPUT -i tailscale0 -p tcp --dport 53 -j ACCEPT
) &

# Execute the original Tailscale entrypoint
exec /usr/local/bin/containerboot
