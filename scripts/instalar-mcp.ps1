# Instalador automático de MCPs do Cursor (ABI/BEES)
# Execute com duplo clique em INSTALAR-MCP.bat

$ErrorActionPreference = "Stop"

function Write-Step($msg)  { Write-Host "`n==> $msg" -ForegroundColor Cyan }
function Write-Ok($msg)    { Write-Host "    OK: $msg" -ForegroundColor Green }
function Write-Warn($msg)  { Write-Host "    AVISO: $msg" -ForegroundColor Yellow }
function Write-Fail($msg)  { Write-Host "    ERRO: $msg" -ForegroundColor Red }

Write-Host ""
Write-Host "========================================" -ForegroundColor White
Write-Host "  Instalador MCP - Cursor (ABI/BEES)" -ForegroundColor White
Write-Host "========================================" -ForegroundColor White

# --- 1. Pasta .cursor ---
Write-Step "Criando pasta de configuracao do Cursor"
$cursorDir = Join-Path $env:USERPROFILE ".cursor"
if (-not (Test-Path $cursorDir)) {
    New-Item -ItemType Directory -Path $cursorDir -Force | Out-Null
}
Write-Ok "Pasta: $cursorDir"

# --- 2. mcp.json ---
Write-Step "Gravando arquivo mcp.json com todos os MCPs basicos"

$mcpJson = @'
{
  "mcpServers": {
    "Figma": {
      "url": "https://mcp.figma.com/mcp",
      "headers": {}
    },
    "sequential-thinking": {
      "command": "cmd",
      "args": [
        "/c",
        "npx",
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ]
    },
    "context7": {
      "url": "https://mcp.context7.com/mcp"
    },
    "atlassian": {
      "url": "https://mcp.atlassian.com/v1/sse"
    },
    "lucidchart": {
      "url": "https://mcp.lucid.app/mcp"
    },
    "granola": {
      "url": "https://mcp.granola.ai/mcp"
    }
  }
}
'@

$mcpPath = Join-Path $cursorDir "mcp.json"
$mcpJson | Set-Content -Path $mcpPath -Encoding UTF8
Write-Ok "Arquivo criado: $mcpPath"

# --- 3. Node.js (para sequential-thinking) ---
Write-Step "Verificando Node.js (necessario para sequential-thinking)"
$nodeOk = $false
try {
    $nodeVersion = & node --version 2>$null
    if ($nodeVersion) {
        Write-Ok "Node.js encontrado: $nodeVersion"
        $nodeOk = $true
    }
} catch {}

if (-not $nodeOk) {
    Write-Warn "Node.js nao encontrado. Tentando instalar automaticamente..."
    $winget = Get-Command winget -ErrorAction SilentlyContinue
    if ($winget) {
        try {
            & winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
            Write-Ok "Node.js instalado via winget. REINICIE o computador depois deste script."
            $nodeOk = $true
        } catch {
            Write-Warn "Nao foi possivel instalar automaticamente."
            Write-Host "    Abra https://nodejs.org e clique no botao LTS (verde)." -ForegroundColor Yellow
        }
    } else {
        Write-Warn "Instale manualmente: https://nodejs.org (botao LTS verde)"
    }
}

# --- 4. Perguntar sobre Databricks (opcional) ---
Write-Step "Databricks (opcional)"
$wantDatabricks = Read-Host "Voce quer configurar o Databricks agora? (s/N)"
if ($wantDatabricks -match '^[sS]') {
    $dbHost = Read-Host "Cole a URL do Databricks (ex: https://adb-123.5.azuredatabricks.net)"
    if ($dbHost) {
        [Environment]::SetEnvironmentVariable("DATABRICKS_HOST", $dbHost, "User")
        Write-Ok "Variavel DATABRICKS_HOST salva"

        $downloads = Join-Path $env:USERPROFILE "Downloads"
        $dbExe = Join-Path $downloads "databricks-mcp-server-windows-amd64.exe"
        if (-not (Test-Path $dbExe)) {
            Write-Warn "Baixando databricks-mcp-server..."
            try {
                $releaseUrl = "https://github.com/characat0/databricks-mcp-server/releases/latest/download/databricks-mcp-server-windows-amd64.exe"
                Invoke-WebRequest -Uri $releaseUrl -OutFile $dbExe -UseBasicParsing
                Write-Ok "Download concluido: $dbExe"
            } catch {
                Write-Fail "Falha no download. Baixe manualmente de:"
                Write-Host "    https://github.com/characat0/databricks-mcp-server/releases" -ForegroundColor Yellow
            }
        } else {
            Write-Ok "Executavel Databricks ja existe em Downloads"
        }

        $azureCliDir = Join-Path $env:USERPROFILE "AzureCLI"
        if (-not (Test-Path (Join-Path $azureCliDir "bin\az.cmd"))) {
            Write-Warn "Azure CLI nao encontrado em $azureCliDir"
            Write-Host "    Baixe de: https://aka.ms/installazurecliwindowszipx64" -ForegroundColor Yellow
            Write-Host "    Extraia para: $azureCliDir" -ForegroundColor Yellow
        } else {
            Write-Ok "Azure CLI encontrado"
        }

        # Adicionar bloco databricks ao mcp.json
        $userHome = $env:USERPROFILE -replace '\\', '\\'
        $mcpObj = $mcpJson | ConvertFrom-Json
        $mcpObj.mcpServers | Add-Member -NotePropertyName "databricks" -NotePropertyValue ([PSCustomObject]@{
            command = "$($env:USERPROFILE)\Downloads\databricks-mcp-server-windows-amd64.exe"
            args    = @()
            env     = [PSCustomObject]@{
                DATABRICKS_HOST = "`${env:DATABRICKS_HOST}"
                PATH            = "$($env:USERPROFILE)\AzureCLI\bin;%PATH%"
            }
        }) -Force
        $mcpObj | ConvertTo-Json -Depth 10 | Set-Content -Path $mcpPath -Encoding UTF8
        Write-Ok "Databricks adicionado ao mcp.json"
    }
}

# --- 5. Fechar Cursor se estiver aberto (para recarregar config) ---
Write-Step "Reiniciando o Cursor"
$cursorProcess = Get-Process -Name "Cursor" -ErrorAction SilentlyContinue
if ($cursorProcess) {
    Write-Warn "Fechando o Cursor para aplicar as configuracoes..."
    $cursorProcess | Stop-Process -Force
    Start-Sleep -Seconds 2
}

# Tentar abrir o Cursor
$cursorPaths = @(
    "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe",
    "$env:LOCALAPPDATA\cursor\Cursor.exe",
    "${env:ProgramFiles}\Cursor\Cursor.exe"
)
$opened = $false
foreach ($p in $cursorPaths) {
    if (Test-Path $p) {
        Start-Process $p
        Write-Ok "Cursor aberto: $p"
        $opened = $true
        break
    }
}
if (-not $opened) {
    Write-Warn "Nao encontrei o Cursor automaticamente. Abra o Cursor manualmente."
}

# --- 6. Resumo final ---
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  INSTALACAO CONCLUIDA!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "O que JA esta pronto:" -ForegroundColor White
Write-Host "  - Figma, Context7, Atlassian, Lucidchart, Granola" -ForegroundColor Gray
Write-Host "  - Sequential Thinking (se Node.js estiver OK)" -ForegroundColor Gray
Write-Host ""
Write-Host "O que VOCE precisa fazer (so na 1a vez, no navegador):" -ForegroundColor Yellow
Write-Host "  1. No Cursor: Ctrl+, -> Tools & MCP -> confira bolinhas verdes" -ForegroundColor Gray
Write-Host "  2. No chat (modo Agent), teste: Me diga quais MCPs voce tem disponiveis" -ForegroundColor Gray
Write-Host "  3. Quando pedir login: use seu email ABI no Figma/Atlassian/etc." -ForegroundColor Gray
Write-Host ""
if ($wantDatabricks -match '^[sS]') {
    Write-Host "Databricks - faca login Azure no chat (modo Agent):" -ForegroundColor Yellow
    Write-Host "  Rode o comando: az login --use-device-code --tenant 80c453cc-7d2c-4e8d-9a60-6e38faf38a99" -ForegroundColor Gray
    Write-Host ""
}
Write-Host "Pressione qualquer tecla para fechar..." -ForegroundColor DarkGray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
