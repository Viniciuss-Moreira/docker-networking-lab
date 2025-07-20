set -e

# Atualiza sistema (Debian/Ubuntu)
sudo apt update && sudo apt upgrade -y

# Instala Docker se não estiver instalado
if ! command -v docker &>/dev/null; then
  echo "[*] Instalando Docker..."
  sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io
  sudo systemctl enable docker
  sudo systemctl start docker
else
  echo "[*] Docker já instalado."
fi

# Instala Docker Compose se não estiver instalado
if ! command -v docker-compose &>/dev/null; then
  echo "[*] Instalando Docker Compose..."
  DOCKER_COMPOSE_VERSION="1.29.2"
  sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
else
  echo "[*] Docker Compose já instalado."
fi

sudo usermod -aG docker $USER

sudo apt install -y curl jq net-tools tcpdump iproute2 iputils-ping

echo "[*] Setup concluído! Reinicie a sessão para aplicar permissões do Docker."