set -e

INTERFACE="docker0"
DURATION=60

# Parâmetros opcionais
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --interface) INTERFACE="$2"; shift ;;
    --capture) DURATION="$2"; shift ;;
    *) echo "Uso: $0 [--interface <iface>] [--capture <segundos>]"; exit 1 ;;
  esac
  shift
done

echo "[*] Capturando tráfego na interface $INTERFACE por $DURATION segundos..."

sudo tcpdump -i "$INTERFACE" -w network_capture.pcap &
TCPDUMP_PID=$!

sleep "$DURATION"

sudo kill $TCPDUMP_PID

tcpdump -r network_capture.pcap -nn -c 20

echo "[*] Capture salva em network_capture.pcap"