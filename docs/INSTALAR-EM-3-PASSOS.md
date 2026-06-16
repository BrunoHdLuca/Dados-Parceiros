# Como instalar os MCPs (3 passos — sem saber programar)

## Passo 1 — Baixar este projeto

1. Abra: https://github.com/BrunoHdLuca/Dados-Parceiros
2. Clique no botão verde **Code** → **Download ZIP**
3. Extraia o ZIP (botão direito → **Extrair tudo**)
4. Abra a pasta extraída `Dados-Parceiros-main` (ou `Dados-Parceiros`)

## Passo 2 — Executar o instalador (duplo clique)

1. Dentro da pasta, encontre o arquivo **`INSTALAR-MCP.bat`**
2. Dê **duplo clique** nele
3. Se o Windows perguntar se pode executar, clique **Sim** ou **Executar**
4. Se pedir permissão de administrador (para instalar Node.js), clique **Sim**
5. Aguarde até aparecer **INSTALAÇÃO CONCLUÍDA!**
6. Se perguntar sobre Databricks e você **não usa dados**, digite **N** e Enter

O instalador faz sozinho:
- Cria o arquivo de configuração do Cursor
- Configura Figma, Jira, Confluence, Context7, Lucidchart e Granola
- Tenta instalar o Node.js se faltar
- Fecha e reabre o Cursor

## Passo 3 — Login no navegador (só na 1ª vez)

Depois que o Cursor abrir:

1. Aperte `Ctrl + L` para abrir o chat
2. Certifique-se de estar no modo **Agent** (canto inferior do chat)
3. Cole e envie:

```
Me diga quais MCPs você tem disponíveis
```

4. Quando o Cursor abrir o **navegador** pedindo login, entre com seu **email da ABI** (o mesmo do Teams)
5. Confira em `Ctrl + ,` → **Tools & MCP** se os MCPs têm **bolinha verde**

Pronto. Não precisa editar nenhum arquivo manualmente.

---

## Se algo der errado

Dê duplo clique de novo em **`INSTALAR-MCP.bat`** ou cole no chat do Cursor:

```
O MCP [nome] está com bolinha vermelha em Settings > Tools & MCP. Me ajude a corrigir.
```

---

## Databricks (só se você usa)

Na instalação, quando perguntar **"configurar Databricks?"**, digite **s**.

Você vai precisar colar a URL do Databricks (copie da barra de endereço quando abrir o Databricks no navegador).

Depois, no chat em modo **Agent**, cole:

```
Rode o comando: az login --use-device-code --tenant 80c453cc-7d2c-4e8d-9a60-6e38faf38a99
```

Siga o código em https://microsoft.com/devicelogin
