@echo off
REM Script para parar containers do SmartServe

cd /d "%~dp0"

echo.
echo ===================================
echo SmartServe - Parar Containers
echo ===================================
echo.

echo Parando e removendo containers...
docker-compose down -v

echo.
echo ===================================
echo Containers Removidos
echo ===================================
echo.

pause

