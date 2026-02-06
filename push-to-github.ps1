#!/usr/bin/env pwsh
# Script para configurar e fazer push para GitHub
# SmartServe API - Git Push Automation

param(
    [string]$RepoName = "smartserve-api",
    [string]$GitHubUser = "edimar1315",
    [string]$Branch = "main"
)

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                   SmartServe API - GitHub Push Script                         ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Cores
$Green = "Green"
$Red = "Red"
$Yellow = "Yellow"
$Blue = "Cyan"

# Função para exibir mensagens coloridas
function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor $Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor $Red
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ️  $Message" -ForegroundColor $Blue
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor $Yellow
}

# Obter diretório atual
$CurrentDir = Get-Location
Write-Info "Diretório atual: $CurrentDir"

# Verificar se está no repositório Git
if (-not (Test-Path ".git")) {
    Write-Error-Custom "Não está em um repositório Git!"
    Write-Host ""
    Write-Host "Execute este script dentro da pasta do projeto."
    exit 1
}

Write-Success "Repositório Git encontrado"

# Verificar se git está instalado
try {
    $GitVersion = git --version
    Write-Success "Git instalado: $GitVersion"
} catch {
    Write-Error-Custom "Git não encontrado! Instale o Git."
    exit 1
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host "CONFIGURAÇÃO" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Yellow
Write-Host ""
Write-Host "Repositório:     $RepoName" -ForegroundColor White
Write-Host "GitHub User:     $GitHubUser" -ForegroundColor White
Write-Host "Branch:          $Branch" -ForegroundColor White
Write-Host "URL:             https://github.com/$GitHubUser/$RepoName.git" -ForegroundColor White
Write-Host ""

# Solicitar confirmação
Write-Host "⚠️  IMPORTANTE!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Antes de continuar, você PRECISA ter criado o repositório no GitHub:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Acesse:  https://github.com/new" -ForegroundColor Cyan
Write-Host "2. Nome:    $RepoName" -ForegroundColor Cyan
Write-Host "3. Público: Sim" -ForegroundColor Cyan
Write-Host "4. Clique:  Create repository" -ForegroundColor Cyan
Write-Host ""

$Confirm = Read-Host "Você criou o repositório no GitHub? (sim/não)"

if ($Confirm -ne "sim" -and $Confirm -ne "s") {
    Write-Host ""
    Write-Host "⏳ Crie o repositório em: https://github.com/new" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Depois execute este script novamente." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "ETAPA 1: Verificar Status do Git Local" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Verificar status
$Status = git status --short
Write-Host "Status dos arquivos:" -ForegroundColor White
if ($Status) {
    Write-Host "Há mudanças não commitadas:" -ForegroundColor Yellow
    Write-Host $Status
    Write-Host ""
    Write-Warning-Custom "Execute 'git add -A' e 'git commit' antes do push"
    exit 1
} else {
    Write-Success "Nenhuma mudança pendente"
}

# Verificar branch
$CurrentBranch = git rev-parse --abbrev-ref HEAD
Write-Host "Branch atual: $CurrentBranch" -ForegroundColor White

if ($CurrentBranch -ne $Branch) {
    Write-Warning-Custom "Você está na branch '$CurrentBranch', não em '$Branch'"
    Write-Host ""
    $SwitchBranch = Read-Host "Deseja trocar para $Branch? (sim/não)"
    if ($SwitchBranch -eq "sim" -or $SwitchBranch -eq "s") {
        git switch -c $Branch
        Write-Success "Branch trocada para $Branch"
    }
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "ETAPA 2: Configurar Remote GitHub" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Verificar se remote já existe
$RemoteUrl = git remote get-url origin 2>$null
if ($RemoteUrl) {
    Write-Host "Remote 'origin' já configurado:" -ForegroundColor White
    Write-Host "  $RemoteUrl" -ForegroundColor Cyan
    
    $ChangeRemote = Read-Host "Deseja manter? (sim/não)"
    if ($ChangeRemote -ne "sim" -and $ChangeRemote -ne "s") {
        Write-Host "Removendo remote antigo..."
        git remote remove origin
        Write-Success "Remote removido"
    }
} else {
    Write-Info "Remote 'origin' não configurado ainda"
}

# Adicionar remote se necessário
if (-not $RemoteUrl -or ($ChangeRemote -ne "sim" -and $ChangeRemote -ne "s")) {
    $RepoUrl = "https://github.com/$GitHubUser/$RepoName.git"
    Write-Host "Adicionando remote: $RepoUrl" -ForegroundColor White
    git remote add origin $RepoUrl
    Write-Success "Remote 'origin' adicionado"
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "ETAPA 3: Fazer Push para GitHub" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Warning-Custom "Aguardando autenticação GitHub..."
Write-Host ""
Write-Host "Se usar Token (recomendado):" -ForegroundColor Yellow
Write-Host "  - URL: https://github.com/settings/tokens" -ForegroundColor Cyan
Write-Host "  - Scope: repo (controle total de repositórios privados e públicos)" -ForegroundColor Cyan
Write-Host ""

# Fazer push
Write-Host "Enviando para GitHub..." -ForegroundColor White
git push -u origin $Branch

if ($LASTEXITCODE -eq 0) {
    Write-Success "Push realizado com sucesso!"
    Write-Host ""
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host "✅ SUCESSO!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
    Write-Host ""
    Write-Host "Seu repositório está disponível em:" -ForegroundColor Green
    Write-Host "  https://github.com/$GitHubUser/$RepoName" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Próximos passos:" -ForegroundColor White
    Write-Host "  1. Abra o link acima" -ForegroundColor Cyan
    Write-Host "  2. Verifique se todos os 21+ arquivos estão lá" -ForegroundColor Cyan
    Write-Host "  3. Configure Settings > Collaborators se quiser adicionar pessoas" -ForegroundColor Cyan
    Write-Host ""
} else {
    Write-Error-Custom "Erro ao fazer push!"
    Write-Host ""
    Write-Host "Verifique:" -ForegroundColor Yellow
    Write-Host "  1. Repositório existe no GitHub" -ForegroundColor Cyan
    Write-Host "  2. Autenticação está correta" -ForegroundColor Cyan
    Write-Host "  3. URL do repositório está correta" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Execute novamente com:" -ForegroundColor Cyan
    Write-Host "  .\push-to-github.ps1" -ForegroundColor White
    exit 1
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "Script finalizado" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

pause

