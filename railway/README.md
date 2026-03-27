# Deploy na Railway

Este repositorio continua usando `docker-compose` para desenvolvimento local, mas agora inclui uma estrutura propria para deploy na Railway com servicos separados.

## Servicos recomendados

Crie estes servicos no mesmo projeto da Railway:

1. `postgres` usando o template nativo da Railway
2. `minio` apontando o `Root Directory` para `railway/minio`
3. `minio-bootstrap` apontando o `Root Directory` para `railway/minio-bootstrap`
4. `builder` apontando o `Root Directory` para `railway/builder`
5. `viewer` apontando o `Root Directory` para `railway/viewer`

O servico `minio` da Railway fica somente com a API S3 publica. O `minio-bootstrap` usa a imagem `minio/mc` para criar o bucket e aplicar a politica publica do prefixo `public/`.

## Volume

Adicione um volume persistente ao servico `minio` montado em `/data`.

## Variaveis de ambiente

Use `.env.railway.example` como referencia e distribua as variaveis assim.

### Builder

- `DATABASE_URL`
- `ENCRYPTION_SECRET`
- `NEXTAUTH_URL`
- `NEXT_PUBLIC_VIEWER_URL`
- `ADMIN_EMAIL`
- `DEFAULT_WORKSPACE_PLAN`
- `SMTP_HOST`
- `SMTP_PORT`
- `SMTP_USERNAME`
- `SMTP_PASSWORD`
- `SMTP_IGNORE_TLS`
- `SMTP_AUTH_DISABLED`
- `NEXT_PUBLIC_SMTP_FROM`
- `S3_ACCESS_KEY`
- `S3_SECRET_KEY`
- `S3_BUCKET`
- `S3_ENDPOINT`
- `S3_PORT`
- `S3_SSL`
- `S3_REGION`

### Viewer

- `DATABASE_URL`
- `ENCRYPTION_SECRET`
- `NEXTAUTH_URL`
- `NEXT_PUBLIC_VIEWER_URL`
- `S3_ACCESS_KEY`
- `S3_SECRET_KEY`
- `S3_BUCKET`
- `S3_ENDPOINT`
- `S3_PORT`
- `S3_SSL`
- `S3_REGION`

### MinIO

- `MINIO_ROOT_USER`
- `MINIO_ROOT_PASSWORD`
- `S3_BUCKET`

Esse servico expõe apenas a API S3 na porta padrao do MinIO.

### MinIO bootstrap

- `MINIO_ENDPOINT`
- `MINIO_ROOT_USER`
- `MINIO_ROOT_PASSWORD`
- `S3_BUCKET`

Esse servico aguarda o `minio` ficar disponivel, cria o bucket automaticamente no boot e aplica acesso publico ao prefixo `public/`.

## Ordem pratica de deploy

1. Suba o `postgres`
2. Suba o `minio`
3. Suba o `minio-bootstrap`
4. Configure os dominios publicos de `builder` e `viewer`
5. Preencha as variaveis com os dominios finais e a conexao do Postgres
6. Suba `builder`
7. Suba `viewer`

## Observacoes

- Em producao, `mailpit` nao deve ser usado; configure um SMTP real.
- Se preferir S3 externo, mantenha `builder` e `viewer` e descarte os servicos `minio` e `minio-bootstrap`.
- O `DATABASE_URL` deve vir do servico Postgres da Railway.
- Se voce precisar do console do MinIO, trate isso como um servico separado e opcional. Nao tente publicar API S3 e console web no mesmo servico da Railway.
