#!/bin/bash -e

if [ -z "$UPLOAD_SOURCE" ]; then
  if [ -n "$UPLOAD_SOURCE_FILE" ]; then
    UPLOAD_SOURCE=$(cat "$UPLOAD_SOURCE_FILE")
    export UPLOAD_SOURCE
  else
    >&2 echo "UPLOAD_SOURCE is not set."
    exit 1
  fi
fi


if [ -z "$STORAGE_ACCOUNT_NAME" ]; then
  if [ -n "$STORAGE_ACCOUNT_NAME_FILE" ]; then
    STORAGE_ACCOUNT_NAME=$(cat "$STORAGE_ACCOUNT_NAME_FILE")
    export STORAGE_ACCOUNT_NAME
  fi
fi

if [ -z "$CONTAINER_NAME" ]; then
  if [ -n "$CONTAINER_NAME_FILE" ]; then
    CONTAINER_NAME=$(cat "$CONTAINER_NAME_FILE")
    export CONTAINER_NAME
  fi
fi

if [ -z "$CONTAINER_PATH" ]; then
  if [ -n "$CONTAINER_PATH_FILE" ]; then
    CONTAINER_PATH=$(cat "$CONTAINER_PATH_FILE")
    export CONTAINER_PATH
  fi
fi


container_url="https://${STORAGE_ACCOUNT_NAME:?}.blob.core.windows.net/${CONTAINER_NAME:?}"
container_path="${CONTAINER_PATH}"

# Login service principal
AZCOPY_SPA_CLIENT_SECRET="${AZURE_CLIENT_SECRET:?}" azcopy login \
  --service-principal \
  --tenant-id "${AZURE_TENANT_ID:?}" \
  --application-id "${AZURE_CLIENT_ID:?}"

# Silently try to create container.
azcopy make "${container_url}" || :

# Sync!
azcopy sync "${UPLOAD_SOURCE}" "${container_url}/${container_path}"
