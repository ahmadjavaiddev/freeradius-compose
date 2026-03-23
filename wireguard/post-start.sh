#!/bin/sh
CONFIG="/config/wg_confs/wg0.conf"

# Fix Address /24 if missing
if grep -q "^Address = 10.0.0.1$" "$CONFIG" 2>/dev/null; then
    sed -i 's|^Address = 10.0.0.1$|Address = 10.0.0.1/24|' "$CONFIG"
    echo "[post-start] Fixed Address to 10.0.0.1/24"
    wg-quick down wg0 2>/dev/null || true
    wg-quick up wg0 2>/dev/null || true
fi

echo "[post-start] WireGuard setup complete"
