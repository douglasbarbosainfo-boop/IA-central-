# Paperclip — instalação

[Paperclip](https://github.com/paperclipai/paperclip) é um servidor Node.js com UI em React
para orquestrar times de agentes de IA (Claude Code, Codex, Cursor, OpenClaw, etc.).
Roda localmente, sem conta no Paperclip.

## Requisitos

- Linux, macOS ou Windows com WSL2 (o Prompt de Comando/PowerShell não roda `bash`)
- Node.js **24.11 ou mais novo** (o instalador instala se faltar)

## Windows (WSL2)

1. Abra o **PowerShell como administrador** e rode `wsl --install`. Reinicie o PC.
2. Abra o app **Ubuntu** no menu Iniciar e crie usuário e senha.
3. No terminal do Ubuntu:

   ```bash
   curl -fsSLO https://paperclip.ing/install.sh
   curl -fsSLO https://paperclip.ing/install.sh.sha256
   sha256sum -c install.sh.sha256
   bash install.sh
   ```

   Se pedir senha, é a do usuário do Ubuntu (ele instala o Node.js com `sudo`).
   Em `Run this command? [y/N]`, digite `y`: só Enter cancela a instalação.

   Se o Ubuntu já tiver um Node.js antigo (erro `requires Node.js 24.11.0 or newer`),
   atualize e rode `bash install.sh` de novo:

   ```bash
   curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
   sudo apt-get install -y nodejs
   hash -r && node --version   # tem que mostrar v24
   ```
4. Sempre rode `paperclipai` pelo Ubuntu e abra **http://localhost:3100** no navegador do Windows.

### Conectar a assinatura do Claude

No Ubuntu, instale o Claude Code, faça login e deixe o `claude` visível para o
serviço do Paperclip (o serviço não enxerga `~/.local/bin`):

```bash
curl -fsSL https://claude.ai/install.sh | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
claude auth login
sudo ln -sf "$HOME/.local/bin/claude" /usr/local/bin/claude
paperclipai service restart
```

Depois clique em **Conectar** na tela "Conecte um modelo".

## Instalar (Linux/macOS)

```bash
bash paperclip/instalar.sh
```

O script baixa o instalador oficial de `paperclip.ing`, confere o checksum e roda.
Ele instala o CLI `paperclipai` em `~/.paperclip/cli` (atalho em `~/.local/bin`) e
abre o assistente de configuração.

Sem perguntas (Node 24 já instalado):

```bash
bash paperclip/instalar.sh --no-prompt --no-onboard
paperclipai onboard --yes
```

Só para testar, sem instalar nada:

```bash
npx --registry https://registry.npmjs.org paperclipai onboard --yes
```

## Usar

```bash
paperclipai run        # sobe o servidor
paperclipai doctor     # diagnóstico
paperclipai health     # checa a API
```

Depois abra **http://127.0.0.1:3100** e crie sua organização.

- Dados e config: `~/.paperclip/instances/default/`
- Rodar em segundo plano (Linux com systemd / macOS): `paperclipai service install`
- Atualizar: `paperclipai update`

## Problema conhecido: rodar como root (Docker, VPS, containers)

Sem `DATABASE_URL`, o Paperclip sobe um PostgreSQL embutido. Como root, esse Postgres
roda com o usuário `postgres`, que não consegue ler `/root` e o servidor cai com:

```
Error: spawn .../@embedded-postgres/linux-x64/native/bin/initdb EACCES
```

Solução: rode com um usuário comum **ou** aponte para um PostgreSQL externo:

```bash
sudo -u postgres psql -c "CREATE ROLE paperclip LOGIN PASSWORD 'paperclip';" \
                      -c "CREATE DATABASE paperclip OWNER paperclip;"
DATABASE_URL=postgres://paperclip:paperclip@localhost:5432/paperclip paperclipai run
```

Troque a senha `paperclip` se o servidor for acessível pela rede.

## Links

- Documentação: https://docs.paperclip.ing
- Código: https://github.com/paperclipai/paperclip
