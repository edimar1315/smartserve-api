<#
fix-setup.ps1 - Script para corrigir problemas de setup (Docker + Migrations)
Resolve: Docker daemon não rodando, dotnet-ef não disponível, migrations não criadas
#>

$ErrorActionPreference = "Continue"
Write-Host "`n=== SmartServe Setup Fix ===" -ForegroundColor Cyan

# 1. Verificar e iniciar Docker Desktop
Write-Host "`n[1/5] Verificando Docker Desktop..." -ForegroundColor Yellow
$dockerProcess = Get-Process -Name "Docker Desktop" -ErrorAction SilentlyContinue
if (-not $dockerProcess) {
    Write-Host "Docker Desktop não está rodando. Tentando iniciar..." -ForegroundColor Yellow
    $dockerPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
    if (Test-Path $dockerPath) {
        Start-Process -FilePath $dockerPath
        Write-Host "Aguardando Docker Desktop inicializar (30 segundos)..." -ForegroundColor Cyan
        Start-Sleep -Seconds 30
    } else {
        Write-Host "ERRO: Docker Desktop não encontrado em $dockerPath" -ForegroundColor Red
        Write-Host "Por favor, inicie o Docker Desktop manualmente e execute este script novamente." -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "Docker Desktop já está em execução." -ForegroundColor Green
}

# Verificar se o daemon está respondendo
Write-Host "Verificando daemon Docker..." -ForegroundColor Cyan
$maxRetries = 6
$retryCount = 0
$dockerReady = $false

while ($retryCount -lt $maxRetries -and -not $dockerReady) {
    $dockerInfo = docker info 2>&1
    if ($LASTEXITCODE -eq 0) {
        $dockerReady = $true
        Write-Host "Docker daemon está pronto!" -ForegroundColor Green
    } else {
        $retryCount++
        Write-Host "Aguardando daemon... tentativa $retryCount de $maxRetries" -ForegroundColor Yellow
        Start-Sleep -Seconds 10
    }
}

if (-not $dockerReady) {
    Write-Host "ERRO: Docker daemon não respondeu após $($maxRetries * 10) segundos." -ForegroundColor Red
    Write-Host "Solução: Abra Docker Desktop manualmente e aguarde inicializar completamente." -ForegroundColor Yellow
    Write-Host "Depois execute este script novamente." -ForegroundColor Yellow
    exit 1
}

# 2. Verificar dotnet-ef
Write-Host "`n[2/5] Verificando dotnet-ef..." -ForegroundColor Yellow
$dotnetToolsPath = Join-Path $env:USERPROFILE ".dotnet\tools"
$env:PATH = "$env:PATH;$dotnetToolsPath"

$efVersion = & "$dotnetToolsPath\dotnet-ef.exe" --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "dotnet-ef não encontrado. Instalando..." -ForegroundColor Yellow
    dotnet tool install --global dotnet-ef
    if ($LASTEXITCODE -eq 0) {
        Write-Host "dotnet-ef instalado com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "ERRO ao instalar dotnet-ef" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "dotnet-ef encontrado: $efVersion" -ForegroundColor Green
}

# 3. Subir containers
Write-Host "`n[3/5] Iniciando containers Docker..." -ForegroundColor Yellow
Set-Location -Path "C:\Users\edima\OneDrive\smartserve\smartserve-api"
docker-compose up -d
if ($LASTEXITCODE -eq 0) {
    Write-Host "Containers iniciados!" -ForegroundColor Green
    Start-Sleep -Seconds 5
    docker-compose ps
} else {
    Write-Host "ERRO ao iniciar containers" -ForegroundColor Red
}

# 4. Gerar migrations
Write-Host "`n[4/5] Gerando migrations..." -ForegroundColor Yellow
Set-Location -Path "C:\Users\edima\OneDrive\smartserve\smartserve-api\SmartServe.Api"

# Verificar se já existe migration
$migrationsPath = "Infrastructure\Persistence\Migrations"
if (Test-Path $migrationsPath) {
    $existingMigrations = Get-ChildItem -Path $migrationsPath -Filter "*.cs" -ErrorAction SilentlyContinue
    if ($existingMigrations.Count -gt 0) {
        Write-Host "Migrations já existem:" -ForegroundColor Green
        $existingMigrations | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor Cyan }
    }
} else {
    Write-Host "Criando migration InitialCreate..." -ForegroundColor Cyan
    & "$dotnetToolsPath\dotnet-ef.exe" migrations add InitialCreate -o Infrastructure/Persistence/Migrations --verbose
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Migration criada com sucesso!" -ForegroundColor Green
    } else {
        Write-Host "ERRO ao criar migration" -ForegroundColor Red
    }
}

# 5. Aplicar migrations
Write-Host "`n[5/5] Aplicando migrations ao banco..." -ForegroundColor Yellow
& "$dotnetToolsPath\dotnet-ef.exe" database update --verbose
if ($LASTEXITCODE -eq 0) {
    Write-Host "Migrations aplicadas com sucesso!" -ForegroundColor Green
} else {
    Write-Host "ERRO ao aplicar migrations" -ForegroundColor Red
    Write-Host "Verifique se o PostgreSQL está rodando: docker-compose ps" -ForegroundColor Yellow
}

# Resumo final
Write-Host "`n=== Resumo ===" -ForegroundColor Cyan
Write-Host "1. Docker daemon: " -NoNewline
if ($dockerReady) { Write-Host "OK" -ForegroundColor Green } else { Write-Host "FALHOU" -ForegroundColor Red }

Write-Host "2. Containers: " -NoNewline
docker-compose ps --format "{{.Service}}: {{.Status}}" 2>&1 | Write-Host -ForegroundColor Cyan

Write-Host "`nPróximos passos:" -ForegroundColor Yellow
Write-Host "  - Verifique os containers: docker-compose ps" -ForegroundColor White
Write-Host "  - Teste a API: dotnet run" -ForegroundColor White
Write-Host "  - Acesse Swagger: http://localhost:5000/swagger" -ForegroundColor White
Write-Host "  - Health check: http://localhost:5000/api/health" -ForegroundColor White

Write-Host "`nSetup concluído!" -ForegroundColor Green

