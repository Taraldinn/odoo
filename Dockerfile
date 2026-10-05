FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        adduser \
        ca-certificates \
        fonts-dejavu-core \
        fonts-freefont-ttf \
        fonts-liberation \
        libmagic1 \
        postgresql-client \
        python3 \
        python3-asn1crypto \
        python3-babel \
        python3-cbor2 \
        python3-chardet \
        python3-cryptography \
        python3-dateutil \
        python3-docutils \
        python3-geoip2 \
        python3-gevent \
        python3-h11 \
        python3-ldap \
        python3-libsass \
        python3-lxml \
        python3-lxml-html-clean \
        python3-magic \
        python3-num2words \
        python3-ofxparse \
        python3-openpyxl \
        python3-passlib \
        python3-pil \
        python3-polib \
        python3-psutil \
        python3-psycopg2 \
        python3-pypdf \
        python3-rjsmin \
        python3-qrcode \
        python3-renderpm \
        python3-reportlab \
        python3-requests \
        python3-serial \
        python3-stdnum \
        python3-usb \
        python3-vobject \
        python3-werkzeug \
        python3-xlrd \
        python3-xlsxwriter \
        python3-zeep \
        wkhtmltopdf \
    && rm -rf /var/lib/apt/lists/* \
    && adduser --system --home /var/lib/odoo --group odoo \
    && mkdir -p /var/lib/odoo \
    && chown -R odoo:odoo /var/lib/odoo

WORKDIR /opt/odoo

COPY . .
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chown -R odoo:odoo /opt/odoo

USER odoo
EXPOSE 8069

ENTRYPOINT ["docker-entrypoint.sh"]