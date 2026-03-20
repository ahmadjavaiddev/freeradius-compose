#!/bin/sh
set -e

sed -i \
  -e "s|__DB_HOST__|${DB_HOST}|g" \
  -e "s|__DB_PASS__|${DB_PASS}|g" \
  /etc/freeradius/mods-available/sql

sed -i \
  -e "s|__RADIUS_SECRET__|${RADIUS_SECRET}|g" \
  /etc/freeradius/clients.conf

# Also update the enabled copy
cp /etc/freeradius/mods-available/sql /etc/freeradius/mods-enabled/sql

exec "$@"