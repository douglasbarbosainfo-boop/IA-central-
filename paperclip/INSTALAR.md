# Paperclip — instalação

[Paperclip](https://github.com/paperclipai/paperclip) é um servidor Node.js com UI em React
para orquestrar times de agentes de IA (Claude Code, Codex, Cursor, OpenClaw, etc.).
Roda localmente, sem conta no Paperclip.

## Requisitos

- Linux ou macOS (no Windows, use WSL2)
- Node.js **24.11 ou mais novo** (o instalador instala se faltar)

## Instalar

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
