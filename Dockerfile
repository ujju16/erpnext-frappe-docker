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

# --- LE CŒUR DU BUILD ---
# On utilise une seule couche (LAYER) pour installer et nettoyer
# Cela évite de faire gonfler l'image inutilement
RUN bench get-app --branch version-15 erpnext && \
    bench install-app erpnext
# Vérification de l'intégrité (Optionnel mais pro)
RUN bench version

# L'image est déjà configurée pour exposer les ports nécessaires via la base	
