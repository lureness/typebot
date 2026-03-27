#!/bin/sh
set -eu

MINIO_ENDPOINT="${MINIO_ENDPOINT:-}"
MINIO_ROOT_USER="${MINIO_ROOT_USER:-}"
MINIO_ROOT_PASSWORD="${MINIO_ROOT_PASSWORD:-}"
S3_BUCKET="${S3_BUCKET:-typebot}"

if [ -z "${MINIO_ENDPOINT}" ]; then
  echo "MINIO_ENDPOINT is required."
  exit 1
fi

if [ -z "${MINIO_ROOT_USER}" ] || [ -z "${MINIO_ROOT_PASSWORD}" ]; then
  echo "MINIO_ROOT_USER and MINIO_ROOT_PASSWORD are required."
  exit 1
fi

TRIES=0
until /usr/bin/mc alias set local "${MINIO_ENDPOINT}" "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" >/dev/null 2>&1; do
  TRIES=$((TRIES + 1))
  if [ "${TRIES}" -ge 60 ]; then
    echo "Failed to connect to MinIO during bootstrap."
    exit 1
  fi
  sleep 2
done

/usr/bin/mc mb --ignore-existing "local/${S3_BUCKET}" >/dev/null 2>&1 || true
/usr/bin/mc anonymous set public "local/${S3_BUCKET}/public" >/dev/null 2>&1 || true

echo "MinIO bucket bootstrap completed."
tail -f /dev/null
