@echo off
REM Script para fazer push para GitHub
REM SmartServe API - GitHub Push Automation
REM Funciona com batch (mais simples que PowerShell)

setlocal enabledelayedexpansion

cls

echo.
echo ╔════════════════════════════════════════════════════════════════════════════════╗
echo ║                   SmartServe API - GitHub Push Script                         ║
echo ╚════════════════════════════════════════════════════════════════════════════════╝
echo.

set REPO_NAME=smartserve-api
set GITHUB_USER=edimar1315
set BRANCH=main

echo.
echo ═══════════════════════════════════════════════════════════════════════════════
echo CONFIGURAÇÃO
echo ═══════════════════════════════════════════════════════════════════════════════
echo.
echo Repositório:     %REPO_NAME%
echo GitHub User:     %GITHUB_USER%
echo Branch:          %BRANCH%
echo URL:             https://github.com/%GITHUB_USER%/%REPO_NAME%.git
echo.

REM Verificar se está em repositório Git
if not exist ".git" (
    echo.
    echo ❌ Erro: Não está em um repositório Git!
    echo.
    echo Execute este script dentro da pasta do projeto.
    echo.
    pause
    exit /b 1
)

echo [OK] Repositório Git encontrado
echo.

REM Verificar status do Git
echo ═══════════════════════════════════════════════════════════════════════════════
echo ETAPA 1: Verificar Status do Git Local
echo ═══════════════════════════════════════════════════════════════════════════════
echo.

git status --short >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo.
    echo ❌ Erro ao verificar status do Git!
    echo.
    pause
    exit /b 1
)

echo [OK] Status verificado
echo.

REM Avisar sobre criação do repositório
echo ═══════════════════════════════════════════════════════════════════════════════
echo AVISO IMPORTANTE
echo ═══════════════════════════════════════════════════════════════════════════════
echo.
echo Antes de continuar, você PRECISA ter criado o repositório no GitHub:
echo.
echo 1. Acesse:  https://github.com/new
echo 2. Nome:    %REPO_NAME%
echo 3. Público: Sim
echo 4. Clique:  Create repository
echo.

set /p CONFIRM="Você criou o repositório no GitHub? (sim/não): "

if /i not "%CONFIRM%"=="sim" if /i not "%CONFIRM%"=="s" (
    echo.
    echo ⏳ Crie o repositório em: https://github.com/new
    echo.
    echo Depois execute este script novamente.
    echo.
    pause
    exit /b 0
)

echo.
echo ═══════════════════════════════════════════════════════════════════════════════
echo ETAPA 2: Configurar Remote GitHub
echo ═══════════════════════════════════════════════════════════════════════════════
echo.

REM Verificar remote
for /f "tokens=*" %%A in ('git remote get-url origin 2^>nul') do set REMOTE_URL=%%A

if defined REMOTE_URL (
    echo Remote 'origin' já configurado:
    echo   %REMOTE_URL%
    echo.
) else (
    echo Remote 'origin' não configurado ainda
    echo.
    echo Adicionando: https://github.com/%GITHUB_USER%/%REPO_NAME%.git
    git remote add origin https://github.com/%GITHUB_USER%/%REPO_NAME%.git
    if !ERRORLEVEL! EQU 0 (
        echo [OK] Remote 'origin' adicionado
    ) else (
        echo.
        echo ❌ Erro ao adicionar remote!
        echo.
        pause
        exit /b 1
    )
)

echo.
echo ═══════════════════════════════════════════════════════════════════════════════
echo ETAPA 3: Fazer Push para GitHub
echo ═══════════════════════════════════════════════════════════════════════════════
echo.

echo ⚠️  Aguardando autenticação GitHub...
echo.
echo Se usar Token (recomendado):
echo   URL: https://github.com/settings/tokens
echo   Scope: repo (controle total)
echo.

echo Enviando para GitHub...
echo.

git push -u origin %BRANCH%

if !ERRORLEVEL! EQU 0 (
    echo.
    echo ═══════════════════════════════════════════════════════════════════════════════
    echo ✅ SUCESSO!
    echo ═══════════════════════════════════════════════════════════════════════════════
    echo.
    echo Seu repositório está disponível em:
    echo   https://github.com/%GITHUB_USER%/%REPO_NAME%
    echo.
    echo Próximos passos:
    echo   1. Abra o link acima
    echo   2. Verifique se todos os 21+ arquivos estão lá
    echo   3. Configure Settings se quiser adicionar colaboradores
    echo.
) else (
    echo.
    echo ═══════════════════════════════════════════════════════════════════════════════
    echo ❌ ERRO ao fazer push!
    echo ═══════════════════════════════════════════════════════════════════════════════
    echo.
    echo Verifique:
    echo   1. Repositório existe no GitHub
    echo   2. Autenticação está correta
    echo   3. URL do repositório está correta
    echo.
    echo Execute novamente com:
    echo   push-to-github.bat
    echo.
    pause
    exit /b 1
)

echo.
echo ═══════════════════════════════════════════════════════════════════════════════
echo Script finalizado
echo ═══════════════════════════════════════════════════════════════════════════════
echo.

pause

