@echo off
REM Script para iniciar containers do SmartServe

cd /d "%~dp0"

echo.
echo ===================================
echo SmartServe - Iniciar Containers
echo ===================================
echo.

echo [1/3] Removendo containers antigos (se existirem)...
docker-compose down -v
echo.

echo [2/3] Iniciando containers...
docker-compose up -d
echo.

echo [3/3] Aguardando servicos iniciarem...
timeout /t 10 /nobreak
echo.

echo.
echo ===================================
echo Status dos Containers
echo ===================================
echo.
docker-compose ps
echo.

echo.
echo ===================================
echo Servicos Disponiveis
echo ===================================
echo.
echo PostgreSQL:  localhost:5432
echo Redis:       localhost:6379
echo RabbitMQ:    localhost:5672 (AMQP) / localhost:15672 (Management)
echo Adminer:     http://localhost:8080
echo.

echo Credenciais PostgreSQL:
echo   User: smartserve_user
echo   Pass: smartserve_password_dev
echo   DB:   smartserve_db
echo.

echo Credenciais RabbitMQ:
echo   User: smartserve
echo   Pass: smartserve_password_dev
echo.

pause

