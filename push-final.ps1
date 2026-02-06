#!/usr/bin/env pwsh
# Script simples para fazer push para GitHub

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                      SmartServe API - Push para GitHub                        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

$RepoPath = "C:\Users\edima\OneDrive\smartserve\smartserve-api"
Set-Location $RepoPath

Write-Host "📁 Diretório: $RepoPath" -ForegroundColor Green
Write-Host ""

# Verificar status
Write-Host "Verificando status do Git..." -ForegroundColor Yellow
git status --short

Write-Host ""
Write-Host "Adicionando todos os arquivos..." -ForegroundColor Yellow
git add -A
Write-Host "✅ Arquivos adicionados" -ForegroundColor Green

Write-Host ""
Write-Host "Fazendo commit..." -ForegroundColor Yellow
git commit -m "Configuração inicial: Entidades de domínio, Infrastructure, Middleware, Docker e documentação completa" 2>&1 | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host "⚠️  Fazendo push para GitHub..." -ForegroundColor Yellow
Write-Host "Se pedir autenticação, use seu Token do GitHub (não a senha)" -ForegroundColor Cyan
Write-Host "Token: https://github.com/settings/tokens" -ForegroundColor Cyan
Write-Host ""

git push -u origin main 2>&1 | ForEach-Object { Write-Host $_ }

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "✅ SUCESSO!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Repositório: https://github.com/edimar1315/smartserve-api" -ForegroundColor Cyan
Write-Host ""

