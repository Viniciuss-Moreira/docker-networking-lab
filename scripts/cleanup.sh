set -e

docker-compose -f scenarios/01-basic-networking/docker-compose.yml down

docker network prune -f

docker volume prune -f

echo "[*] Limpeza concluída"