# Lureness Typebot Stack

Stack isolado do Typebot self-hosted para virar um repositório próprio quando você quiser separar essa infraestrutura do backend principal.

## O que sobe

- `postgres:18`
- `mailpit`
- `minio`
- `createbuckets`
- `typebot-builder`
- `typebot-viewer`

## Rodar localmente

```bash
cp .env.example .env
make up
```

URLs locais padrão:

- Builder: `http://localhost:18080`
- Viewer: `http://localhost:18081`
- Mailpit: `http://localhost:18025`
- MinIO Console: `http://localhost:19001`
- Postgres: `localhost:15432`

## Comandos

```bash
make help
make up
make down
make restart
make logs
make ps
make config
```

## Variáveis principais

```bash
TYPEBOT_BUILDER_URL=http://localhost:18080
TYPEBOT_VIEWER_URL=http://localhost:18081
TYPEBOT_ENCRYPTION_SECRET=
TYPEBOT_POSTGRES_DB=typebot
TYPEBOT_POSTGRES_USER=postgres
TYPEBOT_POSTGRES_PASSWORD=
TYPEBOT_MINIO_ROOT_USER=minio
TYPEBOT_MINIO_ROOT_PASSWORD=
```

## Estrutura pensada para Railway

Este diretório foi montado para poder virar um repositório separado do Typebot. O `docker-compose.yml` serve para operação local e também como referência da topologia que você pode refletir no mesmo projeto do Railway, normalmente com serviços separados para:

- `typebot-builder`
- `typebot-viewer`
- `postgres`
- `minio`

Em Railway, `docker-compose` não sobe tudo automaticamente como um stack único. O uso prático aqui é:

1. manter a infra do Typebot encapsulada em um repositório próprio
2. usar este compose como referência operacional local
3. depois conectar os serviços equivalentes no mesmo projeto do Railway

## Deploy na Railway

Agora o repositório inclui uma estrutura pronta para deploy em serviços separados na Railway:

- `railway/builder`
- `railway/viewer`
- `railway/minio`

Cada diretório contém `Dockerfile` e `railway.toml` próprios, para você apontar o `Root Directory` de cada serviço no painel da Railway. O passo a passo e o mapeamento de variáveis estão em `railway/README.md`.

## Observações

- `SMTP_AUTH_DISABLED=false` já fica ligado para permitir cadastro/login por e-mail
- o bucket público do MinIO é criado automaticamente no serviço `createbuckets`
- o stack usa `postgres:18` no formato novo com mount em `/var/lib/postgresql`
