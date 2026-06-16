@echo off
title Instalador MCP - Cursor ABI/BEES
echo.
echo Iniciando instalacao automatica dos MCPs...
echo (Se pedir permissao de administrador, clique em Sim)
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0instalar-mcp.ps1"

if errorlevel 1 (
    echo.
    echo Algo deu errado. Tente clicar com botao direito neste arquivo
    echo e escolher "Executar como administrador".
    pause
)
