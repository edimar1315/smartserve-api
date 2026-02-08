@echo off
echo ================================================
echo SmartServe API - Correcao Rapida de Setup
echo ================================================
echo.

echo [1/6] Verificando Docker Desktop...
docker info >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERRO] Docker Desktop nao esta rodando!
    echo.
    echo SOLUCAO: Abra o Docker Desktop manualmente:
    echo   1. Pressione Win + S
    echo   2. Digite "Docker Desktop"
    echo   3. Aguarde 30-60 segundos ate ficar pronto
    echo   4. Execute este script novamente
    echo.
    pause
    exit /b 1
)
echo [OK] Docker daemon esta rodando
echo.

echo [2/6] Adicionando dotnet tools ao PATH...
set PATH=%PATH%;%USERPROFILE%\.dotnet\tools
echo [OK] PATH atualizado
echo.

echo [3/6] Verificando dotnet-ef...
dotnet-ef --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [AVISO] dotnet-ef nao encontrado. Instalando...
    dotnet tool install --global dotnet-ef
    echo [OK] dotnet-ef instalado
) else (
    echo [OK] dotnet-ef encontrado
)
echo.

echo [4/6] Subindo containers Docker...
cd /d %~dp0
docker-compose up -d
echo [OK] Containers iniciados
echo.
timeout /t 5 /nobreak >nul

echo [5/6] Gerando migrations...
cd SmartServe.Api
dotnet ef migrations add InitialCreate -o Infrastructure/Persistence/Migrations
if %errorlevel% equ 0 (
    echo [OK] Migration criada
) else (
    echo [AVISO] Migration pode ja existir ou houve erro
)
echo.

echo [6/6] Aplicando migrations ao banco...
dotnet ef database update
if %errorlevel% equ 0 (
    echo [OK] Migrations aplicadas
) else (
    echo [ERRO] Falha ao aplicar migrations
    echo Verifique se o PostgreSQL esta rodando: docker-compose ps
)
echo.

echo ================================================
echo Setup concluido!
echo ================================================
echo.
echo Proximos passos:
echo   1. Teste: dotnet run
echo   2. Acesse: http://localhost:5000/swagger
echo   3. Health: http://localhost:5000/api/health
echo.
pause

