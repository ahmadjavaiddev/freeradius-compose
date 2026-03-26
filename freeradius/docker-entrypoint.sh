#!/bin/sh
set -e

echo "[entrypoint] Substituting environment variables..."

sed -i \
  -e "s|__DB_HOST__|${DB_HOST}|g" \
  -e "s|__DB_PASS__|${DB_PASS}|g" \
  /etc/freeradius/mods-available/sql

cp /etc/freeradius/mods-available/sql /etc/freeradius/mods-enabled/sql

sed -i \
  -e "s|__RADIUS_SECRET__|${RADIUS_SECRET}|g" \
  /etc/freeradius/clients.conf

# --- NEW FIX FOR ACCOUNTING OVERWRITE BUG ---
find /etc/freeradius -name "queries.conf" -type f -exec sed -i 's/%{Acct-Unique-Session-Id}/%{Acct-Session-Id}/g' {} +

echo "[entrypoint] Done. Starting FreeRADIUS..."
exec "$@"