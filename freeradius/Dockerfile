FROM freeradius/freeradius-server:latest

# Cache bust — increment this number to force full rebuild
ARG CACHE_BUST=2

COPY raddb/clients.conf /etc/freeradius/clients.conf
COPY raddb/mods-available/sql /etc/freeradius/mods-available/sql
COPY raddb/sites-enabled/default /etc/freeradius/sites-enabled/default

# Enable sql module (replace symlink with real file)
RUN rm -f /etc/freeradius/mods-enabled/sql && \
    cp /etc/freeradius/mods-available/sql /etc/freeradius/mods-enabled/sql

COPY docker-entrypoint.sh /docker-entrypoint-custom.sh
RUN chmod +x /docker-entrypoint-custom.sh

ENTRYPOINT ["/docker-entrypoint-custom.sh"]
CMD ["freeradius", "-f"]