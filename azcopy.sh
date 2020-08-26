#!/bin/bash -e

source "${BASH_SOURCE%/*}/functions.sh"

ensure-env UPLOAD_SOURCE
ensure-env STORAGE_ACCOUNT_NAME
ensure-env CONTAINER_NAME
ensure-env CONTAINER_PATH ""

ensure-env AZURE_CLIENT_SECRET
ensure-env AZURE_TENANT_ID
ensure-env AZURE_CLIENT_ID

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
