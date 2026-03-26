#!/bin/sh
set -eu

MINIO_PID=""

cleanup() {
  if [ -n "${MINIO_PID}" ]; then
    kill "${MINIO_PID}" 2>/dev/null || true
  fi
}

trap cleanup INT TERM

minio "$@" &
MINIO_PID=$!

TRIES=0
until /usr/bin/mc alias set local http://127.0.0.1:9000 "${MINIO_ROOT_USER}" "${MINIO_ROOT_PASSWORD}" >/dev/null 2>&1; do
  TRIES=$((TRIES + 1))
  if [ "${TRIES}" -ge 30 ]; then
    echo "Failed to connect to MinIO during startup."
    wait "${MINIO_PID}"
    exit 1
  fi
  sleep 2
done

S3_BUCKET="${S3_BUCKET:-typebot}"

/usr/bin/mc mb --ignore-existing "local/${S3_BUCKET}" >/dev/null 2>&1 || true
/usr/bin/mc anonymous set public "local/${S3_BUCKET}/public" >/dev/null 2>&1 || true

wait "${MINIO_PID}"
