@echo off
REM Script de setup do SmartServe API

cd /d "%~dp0SmartServe.Api"

echo.
echo ===================================
echo SmartServe API - Setup Script
echo ===================================
echo.

echo [1/5] Limpando projeto anterior...
dotnet clean

echo.
echo [2/5] Restaurando dependencias...
dotnet restore

echo.
echo [3/5] Compilando projeto...
dotnet build -c Release

echo.
echo [4/5] Criando migration inicial...
dotnet ef migrations add InitialCreate -o Infrastructure/Persistence/Migrations

echo.
echo [5/5] Concluido!
echo.
echo Proximos passos:
echo - Inicie os containers: docker-compose up -d
echo - Atualize o banco: dotnet ef database update
echo - Execute a API: dotnet run
echo.

pause

