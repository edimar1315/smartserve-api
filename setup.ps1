<#
setup.ps1 - Script de setup para desenvolvimento (PowerShell 5.1+)
Este script faz checagens de pré-requisitos, configurações git (credential helper), cria um .env.local a partir do exemplo,
subir a stack Docker, aplicar migrations EF e dá instruções de push seguro (gh / GCM).

Uso:
  Abra PowerShell como Administrador ou usuário com permissão e rode:
  powershell -ExecutionPolicy Bypass -File .\setup.ps1

Observações:
- Não grava secrets no repositório. Editar manualmente o arquivo .env.local gerado.
- Recomenda-se instalar GitHub CLI (gh) e Git Credential Manager (GCM).
#>

function Write-Info($msg) { Write-Host "[INFO]  $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "[WARN]  $msg" -ForegroundColor Yellow }
function Write-Err($msg)  { Write-Host "[ERROR] $msg" -ForegroundColor Red }

$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $Root
Write-Info "Diretório do projeto: $Root"

# Pré-requisitos
$requirements = @("git","dotnet","docker","docker-compose")
$optional = @("gh")

foreach ($cmd in $requirements) {
    if (-not (Get-Command $cmd -ErrorAction SilentlyContinue)) {
        Write-Err "$cmd não encontrado no PATH. Instale antes de continuar."
    } else {
        Write-Info "$cmd encontrado: $(Get-Command $cmd).Source"
    }
}

# Checar gh opcional
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Warn "GitHub CLI (gh) não encontrado. Recomendo instalar para operações seguras com GitHub." 
} else { Write-Info "gh encontrado" }

# Configurar Git credential helper (recomenda GCM - manager-core)
try {
    git config --global credential.helper manager-core 2>$null
    if ($LASTEXITCODE -eq 0) { Write-Info "credential.helper configurado para manager-core" }
} catch { Write-Warn "Não foi possível configurar credential.helper global. Execute manualmente se necessário." }

# Criar .env.local a partir do exemplo
$envExample = Join-Path $Root ".env.local.example"
$envLocal   = Join-Path $Root ".env.local"
if (Test-Path $envLocal) {
    Write-Info ".env.local já existe. Não será sobrescrito." 
} elseif (Test-Path $envExample) {
    Copy-Item -Path $envExample -Destination $envLocal
    Write-Info ".env.local criado a partir de .env.local.example. Edite-o e preencha os valores sensíveis." 
} else {
    Write-Warn ".env.local.example não encontrado. Crie manualmente .env.local com suas variáveis." 
}

# User secrets (opcional): inicializar se o projeto usar user-secrets
# Detectar se há um .csproj no diretório raiz ou em SmartServe.Api
$csproj = Get-ChildItem -Path $Root -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if ($csproj) {
    Write-Info "Projeto detectado: $($csproj.FullName)"
    # Perguntar ao usuário se deseja inicializar user-secrets
    $useSecrets = Read-Host "Deseja inicializar dotnet user-secrets para este projeto? (S/N)"
    if ($useSecrets -match '^[sS]') {
        Write-Info "Inicializando user-secrets..."
        dotnet user-secrets init --project $csproj.FullName
        if ($LASTEXITCODE -eq 0) { Write-Info "User-secrets inicializado (verifique Properties/launchSettings se aplicável)." }
        else { Write-Warn "Falha ao inicializar user-secrets." }
        # Exemplo: solicitar JWT secret, mas NÃO enviar automaticamente para arquivos
        $jwt = Read-Host "Insira um valor temporário para JwtSettings:SecretKey (ou ENTER para pular)"
        if ($jwt -and $jwt.Length -gt 0) {
            dotnet user-secrets set "JwtSettings:SecretKey" "$jwt" --project $csproj.FullName
            if ($LASTEXITCODE -eq 0) { Write-Info "JwtSettings:SecretKey salvo em user-secrets." }
        }
    }
} else {
    Write-Warn "Nenhum .csproj encontrado para dotnet user-secrets init (procure na pasta do projeto)."
}

# Subir serviços docker
$composeFile = Join-Path $Root "docker-compose.yml"
if (Test-Path $composeFile) {
    Write-Info "Iniciando docker-compose..."
    docker-compose up -d
    if ($LASTEXITCODE -eq 0) {
        Write-Info "docker-compose executado. Aguardando containers estabilizarem (5s)..."
        Start-Sleep -Seconds 5
        docker-compose ps
    } else {
        Write-Err "Falha ao executar docker-compose. Verifique o Docker Desktop / demon." 
    }
} else { Write-Warn "docker-compose.yml não encontrado no diretório do script." }

# Restaurar dependências e aplicar migrations
if ($csproj) {
    Write-Info "Restaurando dependências dotnet..."
    dotnet restore $csproj.FullName
    if ($LASTEXITCODE -ne 0) { Write-Err "dotnet restore falhou. Corrija antes de prosseguir." ; exit 1 }

    # Detectar migrations (procura pasta Migrations no projeto)
    $migrationsDir = Join-Path (Split-Path $csproj.FullName -Parent) "Infrastructure\Persistence\Migrations"
    if (Test-Path $migrationsDir -PathType Container) {
        Write-Info "Pasta de migrations encontrada: $migrationsDir"
    } else {
        Write-Info "Nenhuma migration detectada. Criando 'InitialCreate'..."
        dotnet ef migrations add InitialCreate --project $csproj.FullName --output-dir Infrastructure/Persistence/Migrations
        if ($LASTEXITCODE -ne 0) { Write-Warn "Falha ao criar migration (verifique o EF Tools e a string de conexão)." }
    }

    Write-Info "Aplicando migrations: dotnet ef database update"
    dotnet ef database update --project $csproj.FullName
    if ($LASTEXITCODE -ne 0) { Write-Warn "dotnet ef database update falhou. Verifique a connection string e se o banco está acessível." }
}

Write-Info "Setup básico finalizado. Próximos passos sugeridos:"
Write-Host "  - Edite .env.local com valores verdadeiros (não commitar)." -ForegroundColor Green
Write-Host "  - Se preferir, use 'gh auth login' para autenticar com GitHub CLI (mais seguro)." -ForegroundColor Green
Write-Host "  - Faça o primeiro commit e push: git add .; git commit -m 'feat: estrutura inicial'; git push -u origin main" -ForegroundColor Green

Write-Info "Observações finais:"
Write-Host "  - O script NÃO coloca tokens em URLs remotas. Use GCM ou gh para autenticar. " -ForegroundColor Yellow
Write-Host "  - Se quiser criar o repo remoto automaticamente, instale 'gh' e rode: gh repo create edimar1315/smartserve-api --public --source=. --remote=origin --push" -ForegroundColor Yellow

Write-Info "Setup concluído. Boa codificação!"

