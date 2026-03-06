#!/bin/bash
set -e

echo "Création des dossiers de logs (si inexistant)..."

LOG_DIRS=(
    "$HOME/logs/keycloak"
    "$HOME/logs/mariadb"
    "$HOME/logs/mariadb-kc"
    "$HOME/logs/mariadb-wp"
    "$HOME/logs/traefik"
    "$HOME/logs/wordpress"
)

# Créer les dossiers si nécessaire
for dir in "${LOG_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        echo "Créé: $dir"
    else
        echo "Existe déjà: $dir"
    fi
done

echo "Dossiers de logs prêts..."

launch_docker_compose() {
    local folder=$1
    if [ -f "$folder/docker-compose.yml" ]; then
        echo "Arrêt des conteneurs existants dans $folder..."
        docker-compose -f "$folder/docker-compose.yml" down
        echo "Lancement des conteneurs dans $folder..."
        docker-compose -f "$folder/docker-compose.yml" up -d
    else
        echo "Aucun docker-compose.yml trouvé dans $folder"
    fi
}

DOCKER_DIRS=(
    "$HOME/filebeat"
    "$HOME/keycloak"
    "$HOME/traefik"
    "$HOME/wordpress"
)

# Lancer tous les dockers
for dir in "${DOCKER_DIRS[@]}"; do
    launch_docker_compose "$dir"
done

echo "Tous les conteneurs Docker ont été redémarrés."
