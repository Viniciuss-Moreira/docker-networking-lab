set -e

SCENARIO="basic-networking"
CONCURRENT=10
REQUESTS=100

while [[ "$#" -gt 0 ]]; do
  case $1 in
    --scenario) SCENARIO="$2"; shift ;;
    --concurrent) CONCURRENT="$2"; shift ;;
    --requests) REQUESTS="$2"; shift ;;
    *) echo "Uso: $0 [--scenario <nome>] [--concurrent <num>] [--requests <num>]"; exit 1 ;;
  esac
  shift
done

echo "[*] Iniciando teste de desempenho no cenário: $SCENARIO"
cd "scenarios/01-basic-networking" || { echo "Diretório não encontrado"; exit 1; }

# Verifica se ab está instalado
if ! command -v ab &>/dev/null; then
  echo "[*] Apache Bench não encontrado, instalando..."
  sudo apt install -y apache2-utils
fi

echo "[*] Executando teste Apache Bench em http://localhost:8080"
ab -c "$CONCURRENT" -n "$REQUESTS" http://localhost:8080/