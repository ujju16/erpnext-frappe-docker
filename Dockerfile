# Utilisation de l'image de base officielle pour la v15
FROM frappe/erpnext:v15.96.0

USER root

# Installation des outils nécessaires si besoin
RUN apt-get update && apt-get install -y curl git && rm -rf /var/lib/apt/lists/*

USER frappe

# On s'assure que ton fichier apps.json est pris en compte
# GitHub Actions va copier ton apps.json local dans l'image
COPY --chown=frappe:frappe apps.json /opt/frappe/apps.json

# Commande pour installer les apps au moment du build
# APPS_JSON_BASE64 peut être utilisé mais ici on simplifie en lisant le fichier
RUN export APPS_JSON_BASE64=$(base64 -w 0 /opt/frappe/apps.json) && \
    bench get-app --allow-fetch-base-repo erpnext
