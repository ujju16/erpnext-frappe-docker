# Étape 1 : Image de base officielle et stable
FROM frappe/erpnext:v15.96.0

# Métadonnées pour le registry (Cyber-hygiène)
LABEL org.opencontainers.image.source="https://github.com/ujju16/erpnext-frappe-docker"
LABEL org.opencontainers.image.description="Image ERPNext personnalisée avec déploiement CI/CD"
LABEL org.opencontainers.image.licenses=MIT

# On passe en root pour ajuster le système si besoin
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl git && rm -rf /var/lib/apt/lists/*

# IMPORTANT : On se place là où Bench est configuré dans l'image
USER frappe
WORKDIR /home/frappe/frappe-bench

# On copy ton apps.json depuis la racine de ton dépôt GitHub 
# (ton dossier local frappe-docker) vers l'intérieur de l'image
COPY --chown=frappe:frappe apps.json apps.json

# On force la mise à jour des dépendances Python au cas où
RUN ./env/bin/pip install -e apps/frappe -e apps/erpnext

# Nettoyage
RUN find apps -name "*.pyc" -delete && \
    find apps -name "__pycache__" -delete
