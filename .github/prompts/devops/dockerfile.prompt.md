# Prompt: Otimizar Dockerfile

## Objetivo
Criar e otimizar Dockerfile para o projeto SmartServe API com foco em performance, segurança e tamanho da imagem.

## Contexto do Projeto
- **Framework:** ASP.NET Core 8.0+
- **Runtime:** Linux (Alpine)
- **Build:** Multi-stage
- **Registry:** Docker Hub / Azure Container Registry

## Dockerfile Otimizado

```dockerfile
# ====================
# Stage 1: Base Runtime
# ====================
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine AS base
WORKDIR /app

# Configurar porta
EXPOSE 8080
EXPOSE 8081

# Criar usuário não-root para segurança
RUN addgroup -g 1000 appgroup && \
    adduser -u 1000 -G appgroup -s /bin/sh -D appuser && \
    chown -R appuser:appgroup /app

# ====================
# Stage 2: Build
# ====================
FROM mcr.microsoft.com/dotnet/sdk:8.0-alpine AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src

# Copiar apenas arquivos de projeto para cache de layers
COPY ["SmartServe.Api/SmartServe.Api.csproj", "SmartServe.Api/"]

# Restaurar dependências (layer cacheável)
RUN dotnet restore "SmartServe.Api/SmartServe.Api.csproj"

# Copiar código fonte
COPY . .

# Build do projeto
WORKDIR "/src/SmartServe.Api"
RUN dotnet build "SmartServe.Api.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/build \
    --no-restore

# ====================
# Stage 3: Publish
# ====================
FROM build AS publish
ARG BUILD_CONFIGURATION=Release

RUN dotnet publish "SmartServe.Api.csproj" \
    -c $BUILD_CONFIGURATION \
    -o /app/publish \
    --no-restore \
    --no-build \
    /p:UseAppHost=false

# ====================
# Stage 4: Final
# ====================
FROM base AS final
WORKDIR /app

# Copiar artefatos publicados
COPY --from=publish /app/publish .

# Mudar para usuário não-root
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD wget --no-verbose --tries=1 --spider http://localhost:8080/health || exit 1

# Ponto de entrada
ENTRYPOINT ["dotnet", "SmartServe.Api.dll"]
```

## Dockerfile para Desenvolvimento

```dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS development
WORKDIR /app

# Instalar ferramentas
RUN dotnet tool install --global dotnet-ef && \
    dotnet tool install --global dotnet-watch

ENV PATH="${PATH}:/root/.dotnet/tools"

# Copiar arquivos de projeto
COPY . .

# Restaurar dependências
RUN dotnet restore

# Modo watch para hot reload
CMD ["dotnet", "watch", "run", "--project", "SmartServe.Api/SmartServe.Api.csproj", "--urls", "http://0.0.0.0:5000"]
```

## .dockerignore

```
# Diretórios de build
**/bin/
**/obj/
**/out/

# Dependências
**/node_modules/

# Arquivos de IDE
**/.vs/
**/.vscode/
**/.idea/
**/*.user
**/*.suo

# Git
.git/
.gitignore
.gitattributes

# Docker
**/Dockerfile*
**/docker-compose*
**/.dockerignore

# Documentação
**/*.md
**/docs/

# Testes
**/tests/
**/*Tests/

# Logs
**/logs/
**/*.log

# Temporários
**/temp/
**/tmp/
**/.DS_Store
```

## docker-compose.yml (Produção)

```yaml
version: '3.8'

services:
  smartserve-api:
    image: smartserve-api:latest
    build:
      context: .
      dockerfile: Dockerfile
      args:
        BUILD_CONFIGURATION: Release
    container_name: smartserve-api
    restart: unless-stopped
    ports:
      - "5000:8080"
    environment:
      - ASPNETCORE_ENVIRONMENT=Production
      - ASPNETCORE_URLS=http://+:8080
      - ConnectionStrings__DefaultConnection=Host=postgres;Database=smartserve_db;Username=smartserve_user;Password=${DB_PASSWORD}
      - Redis__Host=redis
      - RabbitMQ__Host=rabbitmq
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
      rabbitmq:
        condition: service_healthy
    networks:
      - smartserve-network
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8080/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
        reservations:
          cpus: '0.5'
          memory: 256M

  postgres:
    image: postgres:16-alpine
    container_name: smartserve-postgres
    restart: unless-stopped
    environment:
      POSTGRES_DB: smartserve_db
      POSTGRES_USER: smartserve_user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - smartserve-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U smartserve_user"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    container_name: smartserve-redis
    restart: unless-stopped
    command: redis-server --appendonly yes
    volumes:
      - redis-data:/data
    networks:
      - smartserve-network
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 5s
      retries: 5

  rabbitmq:
    image: rabbitmq:3-management-alpine
    container_name: smartserve-rabbitmq
    restart: unless-stopped
    environment:
      RABBITMQ_DEFAULT_USER: smartserve
      RABBITMQ_DEFAULT_PASS: ${RABBITMQ_PASSWORD}
    volumes:
      - rabbitmq-data:/var/lib/rabbitmq
    networks:
      - smartserve-network
    healthcheck:
      test: ["CMD", "rabbitmq-diagnostics", "-q", "ping"]
      interval: 30s
      timeout: 10s
      retries: 5

volumes:
  postgres-data:
  redis-data:
  rabbitmq-data:

networks:
  smartserve-network:
    driver: bridge
```

## Otimizações Implementadas

### 1. Multi-Stage Build
- **Reduz tamanho:** Imagem final não contém SDK (apenas runtime)
- **Separação:** Build, publish e runtime em stages diferentes
- **Cache:** Layers independentes para melhor cache

### 2. Alpine Linux
```dockerfile
# ~200MB menor que debian
FROM mcr.microsoft.com/dotnet/aspnet:8.0-alpine
```

### 3. Layer Caching
```dockerfile
# Copiar .csproj primeiro (muda menos frequentemente)
COPY ["SmartServe.Api/SmartServe.Api.csproj", "SmartServe.Api/"]
RUN dotnet restore

# Copiar código depois (muda mais frequentemente)
COPY . .
```

### 4. Usuário Não-Root
```dockerfile
# Segurança: não executar como root
RUN adduser -u 1000 -G appgroup -s /bin/sh -D appuser
USER appuser
```

### 5. Health Check
```dockerfile
HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget --spider http://localhost:8080/health || exit 1
```

### 6. Build Arguments
```dockerfile
ARG BUILD_CONFIGURATION=Release
RUN dotnet build -c $BUILD_CONFIGURATION
```

## Comandos Docker

### Build
```bash
# Build local
docker build -t smartserve-api:latest .

# Build com tag específica
docker build -t smartserve-api:v1.0.0 .

# Build com argumentos
docker build --build-arg BUILD_CONFIGURATION=Debug -t smartserve-api:debug .

# Build sem cache
docker build --no-cache -t smartserve-api:latest .
```

### Run
```bash
# Executar container
docker run -d -p 5000:8080 --name smartserve-api smartserve-api:latest

# Com variáveis de ambiente
docker run -d -p 5000:8080 \
  -e ASPNETCORE_ENVIRONMENT=Production \
  -e ConnectionStrings__DefaultConnection="..." \
  smartserve-api:latest

# Com volume para logs
docker run -d -p 5000:8080 \
  -v /var/log/smartserve:/app/logs \
  smartserve-api:latest
```

### Docker Compose
```bash
# Iniciar todos os serviços
docker-compose up -d

# Build e iniciar
docker-compose up -d --build

# Ver logs
docker-compose logs -f smartserve-api

# Parar
docker-compose down

# Parar e remover volumes
docker-compose down -v
```

### Inspeção e Debug
```bash
# Ver logs
docker logs smartserve-api

# Entrar no container
docker exec -it smartserve-api /bin/sh

# Ver recursos
docker stats smartserve-api

# Inspecionar imagem
docker inspect smartserve-api:latest

# Ver tamanho das layers
docker history smartserve-api:latest
```

## Análise de Segurança

### Scan de Vulnerabilidades
```bash
# Docker Scout (nativo)
docker scout cves smartserve-api:latest

# Trivy
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  aquasec/trivy image smartserve-api:latest

# Snyk
snyk container test smartserve-api:latest
```

## CI/CD Integration

### GitHub Actions
```yaml
- name: Build Docker Image
  run: docker build -t smartserve-api:${{ github.sha }} .

- name: Push to Registry
  run: |
    echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
    docker push smartserve-api:${{ github.sha }}
```

### Azure DevOps
```yaml
- task: Docker@2
  inputs:
    command: buildAndPush
    repository: smartserve-api
    dockerfile: Dockerfile
    tags: |
      $(Build.BuildId)
      latest
```

## Tamanho da Imagem

| Versão | Tamanho | Observações |
|--------|---------|-------------|
| debian | ~210MB | Imagem padrão |
| alpine | ~110MB | 50% menor |
| alpine + otimizações | ~95MB | Produção ideal |

## Boas Práticas

### ✅ Fazer
- Usar multi-stage builds
- Preferir imagens Alpine
- Usuário não-root
- Health checks
- .dockerignore completo
- Scan de segurança
- Versionar imagens (tags)
- Limitar recursos (CPU, memória)

### ❌ Evitar
- Copiar arquivos desnecessários
- Executar como root
- Imagens sem versão (`:latest` em prod)
- Secrets em environment variables
- Instalar ferramentas desnecessárias
- Múltiplas instruções RUN (consolidar)

## Troubleshooting

### Imagem muito grande
```bash
# Analisar layers
docker history smartserve-api:latest --no-trunc

# Usar dive para análise detalhada
dive smartserve-api:latest
```

### Build lento
```bash
# Verificar cache
docker build --progress=plain .

# Usar BuildKit
DOCKER_BUILDKIT=1 docker build -t smartserve-api .
```

## Exemplo de Uso

```
@workspace Use o prompt .github/prompts/devops/dockerfile.prompt.md 
para otimizar o Dockerfile do projeto focando em segurança e tamanho da imagem
```

## Checklist

- [ ] Multi-stage build implementado
- [ ] Imagem Alpine utilizada
- [ ] .dockerignore configurado
- [ ] Usuário não-root
- [ ] Health check configurado
- [ ] Variáveis de ambiente externalizadas
- [ ] Scan de segurança executado
- [ ] Tamanho da imagem <150MB
- [ ] docker-compose.yml para desenvolvimento
- [ ] Documentação de comandos

