FROM freeradius/freeradius-server:latest

ARG CACHE_BUST=3

COPY raddb/clients.conf /etc/freeradius/clients.conf
COPY raddb/mods-available/sql /etc/freeradius/mods-available/sql
COPY raddb/sites-enabled/default /etc/freeradius/sites-enabled/default

# Remove existing symlink and copy fresh from our custom mods-available/sql
RUN rm -f /etc/freeradius/mods-enabled/sql && \
    cp /etc/freeradius/mods-available/sql /etc/freeradius/mods-enabled/sql && \
    chmod 640 /etc/freeradius/mods-enabled/sql

COPY docker-entrypoint.sh /docker-entrypoint-custom.sh
RUN chmod +x /docker-entrypoint-custom.sh

ENTRYPOINT ["/docker-entrypoint-custom.sh"]
CMD ["freeradius", "-f"]