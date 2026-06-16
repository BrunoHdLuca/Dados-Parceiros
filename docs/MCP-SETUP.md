# Configuração MCP no Cursor (ABI/BEES)

Este repositório já inclui os arquivos de configuração MCP recomendados pelo guia da ABI. Siga os passos abaixo no **seu computador Windows**.

## Arquivos neste repositório

| Arquivo | Uso |
|---------|-----|
| `.cursor/mcp.json` | **Comece por aqui** — 6 MCPs prontos, sem segredos |
| `.cursor/mcp.avancado.exemplo.json` | Blocos opcionais (Docker Atlassian + Databricks) |
| `.cursor/mcp.completo.exemplo.json` | Todos os MCPs juntos, com variáveis de ambiente |
| `.env.example` | Lista de variáveis que você precisa definir (avançado) |

---

## Passo 1 — Copiar a configuração para o Cursor (obrigatório)

O MCP roda no Cursor **instalado no seu PC**, não na nuvem. Você precisa colar o conteúdo no arquivo global do Cursor.

1. Abra o **Cursor** no Windows
2. `Ctrl + ,` → menu **Tools & MCP**
3. Clique em **Add new global MCP server** (abre o `mcp.json` global)
4. **Substitua todo o conteúdo** pelo arquivo `.cursor/mcp.json` deste repositório
5. `Ctrl + S` para salvar
6. **Feche o Cursor completamente** (`Alt + F4`) e abra de novo

Caminho do arquivo global no Windows: `%USERPROFILE%\.cursor\mcp.json`

---

## Passo 2 — O que já fica pronto (só reiniciar + login no browser)

Estes MCPs estão em `.cursor/mcp.json` e funcionam sem instalar nada extra:

| MCP | Na primeira vez |
|-----|-----------------|
| **Figma** | Login no Figma pelo navegador |
| **Context7** | Nada — já funciona |
| **Atlassian** (Jira/Confluence) | Login com email ABI no navegador |
| **Lucidchart** | Login no Lucidchart pelo navegador |
| **Granola** | Login no Granola pelo navegador |

**Teste no chat:** `Me diga quais MCPs você tem disponíveis`

---

## Passo 3 — Sequential Thinking (precisa de Node.js)

Já está no `mcp.json`. Só funciona se o Node.js estiver instalado.

1. No `cmd`, rode: `node --version`
2. Se der erro, instale em https://nodejs.org (botão **LTS**)
3. Reinicie o PC e depois o Cursor
4. Em **Tools & MCP**, confira se `sequential-thinking` tem bolinha verde

---

## Passo 4 — MCPs avançados (opcional)

Use **somente** se precisar. Não é obrigatório ativar todos.

### Atlassian via Docker (alternativa ao login OAuth)

**Quando usar:** se o MCP `atlassian` (OAuth) não atender, ou alguém do time pedir a versão Docker.

**Você precisa:**
1. Docker Desktop instalado e rodando (ícone da baleia na barra de tarefas)
2. API Token em https://id.atlassian.com/manage-profile/security/api-tokens (label: `cursor-mcp`)
3. Variáveis de ambiente no Windows:
   - `ATLASSIAN_EMAIL` = seu email `@ab-inbev.com`
   - `ATLASSIAN_API_TOKEN` = token copiado
4. Copiar o bloco `mcp-atlassian` de `.cursor/mcp.avancado.exemplo.json` para dentro de `mcpServers` no seu `mcp.json` global (não esqueça a vírgula entre blocos)
5. Reiniciar o Cursor

### Databricks

**Você precisa:**
1. Baixar `databricks-mcp-server-windows-amd64.exe` em https://github.com/characat0/databricks-mcp-server/releases → pasta **Downloads**
2. Baixar e extrair Azure CLI em `C:\Users\SEU_USUARIO\AzureCLI` — https://aka.ms/installazurecliwindowszipx64
3. Anotar a URL do Databricks (começa com `https://adb-` e termina com `.azuredatabricks.net`)
4. Definir variável de ambiente `DATABRICKS_HOST` com essa URL
5. Copiar o bloco `databricks` de `.cursor/mcp.avancado.exemplo.json` para o `mcp.json` global
6. Reiniciar o Cursor
7. **Login Azure (primeira vez e quando expirar ~1h)** — no chat em modo **Agent**:

```
Rode o comando: az login --use-device-code --tenant 80c453cc-7d2c-4e8d-9a60-6e38faf38a99
```

Siga o código em https://microsoft.com/devicelogin com seu email ABI.

**Teste:** `Execute no Databricks: SELECT 1 as teste`

---

## Passo 5 — Verificar

1. `Ctrl + ,` → **Tools & MCP**
2. Cada MCP deve ter **bolinha verde**
3. Se estiver vermelho: **Output** (`Ctrl + Shift + U`) → dropdown **MCP Logs**

| Status | Significado |
|--------|-------------|
| Verde | OK |
| Vermelho | Erro — veja MCP Logs ou peça ajuda no chat |
| Não aparece | Erro de JSON no `mcp.json` (vírgula, chave) |

---

## Resumo: o que é automático vs manual

| Item | Quem faz |
|------|----------|
| Arquivos `mcp.json` no repositório | Já feito (este PR) |
| Colar no `mcp.json` global do Cursor | **Você** (Passo 1) |
| Reiniciar o Cursor após mudanças | **Você** |
| Login OAuth (Figma, Atlassian, Lucidchart, Granola) | **Você** (na 1ª vez) |
| Instalar Node.js (sequential-thinking) | **Você** (se ainda não tiver) |
| Docker + token Atlassian (opcional) | **Você** |
| Downloads + Azure login Databricks (opcional) | **Você** |

---

## Problemas comuns

Cole no chat do Cursor:

```
O MCP [NOME] está com status vermelho em Settings > Tools & MCP. Me ajude a diagnosticar.
```

Token Azure expirado (Databricks):

```
Rode o comando: az login --use-device-code --tenant 80c453cc-7d2c-4e8d-9a60-6e38faf38a99
```
