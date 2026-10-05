#!/bin/sh
set -eu

: "${POSTGRES_PASSWORD:?POSTGRES_PASSWORD is required}"
: "${ODOO_ADMIN_PASSWORD:?ODOO_ADMIN_PASSWORD is required}"

ODOO_CONFIG_FILE="${ODOO_CONFIG_FILE:-/tmp/odoo.conf}"
umask 077
printf '[options]\nadmin_passwd = %s\n' "$ODOO_ADMIN_PASSWORD" > "$ODOO_CONFIG_FILE"

if [ -n "${POSTGRES_DB:-}" ]; then
    set -- --database="$POSTGRES_DB" "$@"
fi

exec python3 /opt/odoo/odoo-bin \
    --config="$ODOO_CONFIG_FILE" \
    --http-interface=0.0.0.0 \
    --http-port=8069 \
    --proxy-mode \
    --data-dir=/var/lib/odoo \
    --db_host="${POSTGRES_HOST:-db}" \
    --db_port="${POSTGRES_PORT:-5432}" \
    --db_user="${POSTGRES_USER:-odoo}" \
    --db_password="$POSTGRES_PASSWORD" \
    "$@"
