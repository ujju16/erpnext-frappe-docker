# Étape 1 : Image de base officielle et stable
FROM frappe/erpnext:v15.96.0

# Métadonnées pour le registre (Cyber-hygiène)
LABEL org.opencontainers.image.source="https://github.com/ujju16/erpnext-frappe-docker"
LABEL org.opencontainers.image.description="Image ERPNext personnalisée avec déploiement CI/CD"
LABEL org.opencontainers.image.licenses=MIT

USER root

# Installation des dépendances système minimales (si besoin de compiler certains packages)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Retour à l'utilisateur frappe pour la sécurité (Principe du moindre privilège)
USER frappe

# On définit le répertoire de travail officiel
WORKDIR /home/frappe/frappe-bench

# Copie sécurisée du fichier de configuration des apps
COPY --chown=frappe:frappe apps.json apps.json

RUN bench get-app --branch version-15 erpnext && \
    find apps -name "*.pyc" -delete && \
    find apps -name "__pycache__" -delete
