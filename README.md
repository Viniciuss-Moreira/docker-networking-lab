# Docker Networking Lab

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Docker](https://img.shields.io/badge/docker-20.10+-blue.svg)
![Docker Compose](https://img.shields.io/badge/docker--compose-1.29+-blue.svg)
![Network](https://img.shields.io/badge/networking-containers-green.svg)

## 🐳 Descrição

Laboratório completo para estudo e simulação de redes containerizadas usando Docker e Docker Compose. Este repositório oferece cenários práticos para entender networking em containers, microsserviços, e implementação de firewalls e proxies em ambientes containerizados.

## 🎯 Objetivos do Laboratório

- **Compreender networking Docker**: Bridge, Host, Overlay networks
- **Implementar microsserviços**: Comunicação entre containers
- **Configurar proxies reversos**: Nginx, Traefik, HAProxy  
- **Simular ambientes reais**: Load balancing, service discovery
- **Implementar segurança**: Network policies, firewalls
- **Monitorar tráfego**: Observabilidade e debugging

## 📁 Estrutura do Projeto

```
docker-networking-lab/
├── scenarios/
│   ├── 01-basic-networking/
│   │   ├── docker-compose.yml
│   │   ├── Dockerfile.web
│   │   └── configs/
│   ├── 02-microservices/
│   │   ├── docker-compose.yml
│   │   ├── services/
│   │   │   ├── frontend/
│   │   │   ├── backend/
│   │   │   └── database/
│   │   └── configs/
│   ├── 03-reverse-proxy/
│   │   ├── nginx/
│   │   ├── traefik/
│   │   └── haproxy/
│   ├── 04-load-balancer/
│   ├── 05-service-mesh/
│   └── 06-security/
├── scripts/
│   ├── setup-environment.sh
│   ├── network-analyzer.sh
│   ├── performance-test.sh
│   └── cleanup.sh
├── monitoring/
│   ├── prometheus/
│   ├── grafana/
│   └── elk-stack/
├── security/
│   ├── firewall-rules/
│   ├── network-policies/
│   └── ssl-certificates/
├── docs/
│   ├── networking-concepts.md
│   ├── troubleshooting.md
│   └── best-practices.md
└── README.md
```

## 🚀 Cenários de Laboratório

### 📡 Cenário 1: Networking Básico
**Objetivo**: Entender conceitos fundamentais de rede Docker
```yaml
# docker-compose.yml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "8080:80"
    networks:
      - frontend
  
  api:
    image: nginx:alpine
    networks:
      - frontend
      - backend
  
  database:
    image: postgres:13
    networks:
      - backend
    environment:
      POSTGRES_DB: testdb
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass

networks:
  frontend:
    driver: bridge
  backend:
    driver: bridge
    internal: true
```

### 🏗️ Cenário 2: Arquitetura de Microsserviços
**Objetivo**: Implementar comunicação entre microsserviços
```yaml
version: '3.8'
services:
  frontend:
    build: ./services/frontend
    ports:
      - "3000:3000"
    depends_on:
      - backend
    networks:
      - web-tier

  backend:
    build: ./services/backend
    ports:
      - "5000:5000"
    depends_on:
      - database
      - redis
    networks:
      - web-tier
      - app-tier

  database:
    image: postgres:13
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: app
      POSTGRES_PASSWORD: secret
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-tier

  redis:
    image: redis:6-alpine
    networks:
      - app-tier

networks:
  web-tier:
    driver: bridge
  app-tier:
    driver: bridge
    internal: true

volumes:
  postgres_data:
```

### 🔀 Cenário 3: Reverse Proxy com Nginx
**Objetivo**: Implementar proxy reverso para balanceamento de carga
```yaml
version: '3.8'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/ssl:/etc/ssl/certs
    depends_on:
      - web1
      - web2
    networks:
      - proxy-net

  web1:
    image: nginx:alpine
    volumes:
      - ./web/index1.html:/usr/share/nginx/html/index.html
    networks:
      - proxy-net

  web2:
    image: nginx:alpine
    volumes:
      - ./web/index2.html:/usr/share/nginx/html/index.html
    networks:
      - proxy-net

networks:
  proxy-net:
    driver: bridge
```

### ⚖️ Cenário 4: Load Balancer Avançado
**Objetivo**: Implementar diferentes estratégias de balanceamento
- Round Robin
- Least Connections  
- IP Hash
- Health Checks

### 🕸️ Cenário 5: Service Mesh com Istio
**Objetivo**: Implementar service mesh para comunicação segura
- Traffic management
- Security policies
- Observability
- Chaos engineering

### 🔒 Cenário 6: Segurança de Rede
**Objetivo**: Implementar políticas de segurança
- Network policies
- Container firewall
- SSL/TLS termination
- Secret management

## ⚡ Setup e Configuração

### Pré-requisitos
```bash
# Verificar versão do Docker
docker --version  # >= 20.10

# Verificar Docker Compose
docker-compose --version  # >= 1.29

# Instalar ferramentas auxiliares
sudo apt install curl jq net-tools tcpdump wireshark
```

### Setup Inicial
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/docker-networking-lab.git
cd docker-networking-lab

# Configurar ambiente
./scripts/setup-environment.sh

# Verificar instalação
docker network ls
docker-compose --version
```

### Executar Cenários
```bash
# Cenário básico
cd scenarios/01-basic-networking
docker-compose up -d

# Verificar conectividade
docker-compose exec web ping api
docker-compose exec api ping database

# Monitorar logs
docker-compose logs -f
```

## 🔧 Comandos Úteis

### Gerenciamento de Redes
```bash
# Listar redes Docker
docker network ls

# Inspecionar rede específica
docker network inspect bridge

# Criar rede customizada
docker network create --driver bridge my-network

# Conectar container à rede
docker network connect my-network container-name

# Remover redes não utilizadas
docker network prune
```

### Análise de Conectividade
```bash
# Testar conectividade entre containers
docker exec container1 ping container2

# Verificar portas abertas
docker exec container netstat -tlnp

# Rastrear rota de rede
docker exec container traceroute google.com

# Capturar tráfego de rede
docker exec container tcpdump -i eth0
```

### Debugging de Rede
```bash
# Entrar no namespace de rede do container
docker exec -it container /bin/bash

# Verificar configuração de rede
docker exec container ip addr show
docker exec container ip route show

# Testar DNS
docker exec container nslookup google.com
docker exec container dig @8.8.8.8 google.com
```

## 📊 Monitoramento e Observabilidade

### Prometheus + Grafana
```yaml
# monitoring/docker-compose.yml
version: '3.8'
services:
  prometheus:
    image: prom/prometheus
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
    networks:
      - monitoring

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - monitoring

networks:
  monitoring:
    driver: bridge

volumes:
  grafana_data:
```

### cAdvisor para Métricas de Container
```yaml
  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
    networks:
      - monitoring
```

### ELK Stack para Logs
```yaml
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.14.0
    environment:
      - discovery.type=single-node
    ports:
      - "9200:9200"
    networks:
      - elk

  kibana:
    image: docker.elastic.co/kibana/kibana:7.14.0
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    networks:
      - elk
```

## 🔒 Implementação de Segurança

### Network Policies
```yaml
# security/network-policy.yml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all-ingress
spec:
  podSelector: {}
  policyTypes:
  - Ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web-to-api
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: web
    ports:
    - protocol: TCP
      port: 5000
```

### Container Firewall com iptables
```dockerfile
# Dockerfile com regras de firewall
FROM ubuntu:20.04
RUN apt-get update && apt-get install -y iptables
COPY firewall-rules.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/firewall-rules.sh
ENTRYPOINT ["/usr/local/bin/firewall-rules.sh"]
```

### SSL/TLS Configuration
```nginx
# nginx/ssl.conf
server {
    listen 443 ssl http2;
    server_name localhost;
    
    ssl_certificate /etc/ssl/certs/server.crt;
    ssl_certificate_key /etc/ssl/certs/server.key;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;
    
    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🧪 Testes e Validação

### Performance Testing
```bash
# Teste de carga com Apache Bench
./scripts/performance-test.sh --scenario basic-networking --concurrent 100 --requests 1000

# Teste de latência
docker exec web ping -c 10 api

# Teste de throughput
docker exec web iperf3 -c api
```

### Network Analysis
```bash
# Análise de tráfego de rede
./scripts/network-analyzer.sh --capture 60 --interface docker0

# Verificar bandwidth utilizado
docker stats --format "table {{.Container}}\t{{.NetIO}}"

# Monitorar conexões ativas
docker exec container ss -tuln
```

### Chaos Engineering
```bash
# Simular falha de rede
docker network disconnect bridge container-name

# Simular latência
docker exec container tc qdisc add dev eth0 root netem delay 100ms

# Simular perda de pacotes
docker exec container tc qdisc add dev eth0 root netem loss 5%
```

## 🔧 Troubleshooting Common Issues

### Container não consegue se conectar
```bash
# Verificar se containers estão na mesma rede
docker network inspect network-name

# Verificar resolução DNS
docker exec container nslookup other-container

# Verificar regras de firewall
docker exec container iptables -L
```

### Performance Issues
```bash
# Verificar utilização de recursos
docker stats

# Analisar logs de rede
docker logs container-name | grep network

# Verificar MTU
docker exec container ip link show
```

### SSL/TLS Issues
```bash
# Testar certificado
openssl s_client -connect localhost:443

# Verificar configuração SSL
docker exec nginx nginx -t

# Debug SSL handshake
curl -vvv https://localhost
```

## 📚 Laboratórios Práticos

### Lab 1: Multi-tier Application
**Duração**: 2 horas
**Objetivos**:
- Implementar aplicação web com frontend, backend e database
- Configurar comunicação segura entre camadas
- Implementar health checks

### Lab 2: Service Discovery
**Duração**: 3 horas  
**Objetivos**:
- Implementar Consul para service discovery
- Configurar load balancing dinâmico
- Implementar failover automático

### Lab 3: Container Security
**Duração**: 4 horas
**Objetivos**:
- Implementar network policies
- Configurar container firewall
- Implementar secrets management

### Lab 4: Observability
**Duração**: 3 horas
**Objetivos**:
- Implementar stack de monitoramento
- Configurar alertas
- Criar dashboards personalizados

## 📄 Licença

Este projeto está licenciado sob a Licença Apache 2.0 - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 👨‍💻 Autor

**Vinicius Moreira**
- GitHub: [@Viniciuss-Moreira](https://github.com/Viniciuss-Moreira)
- LinkedIn: [Vinicius Moreira](https://linkedin.com/in/viniciusmoreira-)
- Email: vinnismoreira@gmail.com