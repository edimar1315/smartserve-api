@echo off
REM Script de diagnostico do SmartServe API

setlocal enabledelayedexpansion

cd /d "%~dp0"

echo.
echo ===================================
echo SmartServe API - Diagnostico
echo ===================================
echo.

echo [INFO] Diretorio atual: %cd%
echo.

echo [1/7] Verificando .NET SDK...
dotnet --version
if !ERRORLEVEL! EQU 0 (
    echo [OK] .NET SDK instalado
) else (
    echo [ERRO] .NET SDK nao encontrado
    goto :error
)
echo.

echo [2/7] Verificando Docker...
docker --version
if !ERRORLEVEL! EQU 0 (
    echo [OK] Docker instalado
) else (
    echo [ERRO] Docker nao encontrado
    goto :error
)
echo.

echo [3/7] Verificando Docker Compose...
docker-compose --version
if !ERRORLEVEL! EQU 0 (
    echo [OK] Docker Compose instalado
) else (
    echo [ERRO] Docker Compose nao encontrado
    goto :error
)
echo.

echo [4/7] Verificando Git...
git --version
if !ERRORLEVEL! EQU 0 (
    echo [OK] Git instalado
) else (
    echo [ERRO] Git nao encontrado
    goto :error
)
echo.

echo [5/7] Verificando estrutura de projeto...
if exist "SmartServe.Api\" (
    echo [OK] Pasta SmartServe.Api encontrada
) else (
    echo [ERRO] Pasta SmartServe.Api nao encontrada
    goto :error
)
echo.

echo [6/7] Verificando arquivo .csproj...
if exist "SmartServe.Api\SmartServe.Api.csproj" (
    echo [OK] Arquivo .csproj encontrado
) else (
    echo [ERRO] Arquivo .csproj nao encontrado
    goto :error
)
echo.

echo [7/7] Verificando docker-compose.yml...
if exist "docker-compose.yml" (
    echo [OK] Arquivo docker-compose.yml encontrado
) else (
    echo [ERRO] Arquivo docker-compose.yml nao encontrado
    goto :error
)
echo.

echo ===================================
echo DIAGNOSTICO CONCLUIDO COM SUCESSO
echo ===================================
echo.
echo Tudo pronto! Voce pode executar setup.bat para continuar.
echo.
pause
exit /b 0

:error
echo.
echo ===================================
echo ERRO NO DIAGNOSTICO
echo ===================================
echo.
pause
exit /b 1

