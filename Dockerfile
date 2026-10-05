FROM python:3.12-slim-bookworm

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        fonts-dejavu \
        fonts-freefont-ttf \
        fonts-liberation \
        libffi-dev \
        libjpeg62-turbo-dev \
        libldap2-dev \
        libmagic1 \
        libpq-dev \
        libsasl2-dev \
        libssl-dev \
        libxml2-dev \
        libxslt1-dev \
        wkhtmltopdf \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --home-dir /var/lib/odoo --shell /bin/bash odoo \
    && mkdir -p /var/lib/odoo \
    && chown -R odoo:odoo /var/lib/odoo

WORKDIR /opt/odoo

COPY requirements.txt setup.py MANIFEST.in ./
COPY odoo/release.py odoo/release.py
RUN pip install -r requirements.txt

COPY . .
RUN pip install --no-deps .
RUN chown -R odoo:odoo /opt/odoo

USER odoo
EXPOSE 8069

ENTRYPOINT ["odoo-bin"]