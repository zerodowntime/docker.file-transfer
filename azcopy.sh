#!/bin/bash -e

source "${BASH_SOURCE%/*}/functions.sh"

ensure-env UPLOAD_SOURCE
ensure-env STORAGE_ACCOUNT_NAME
ensure-env CONTAINER_NAME
ensure-env CONTAINER_PATH ""

ensure-env AZURE_CLIENT_SECRET
ensure-env AZURE_TENANT_ID
ensure-env AZURE_CLIENT_ID

# 'true', 'false', 'prompt', and 'ifSourceNewer'
ensure-env AZCOPY_OVERWRITE "true"


container_url="https://${STORAGE_ACCOUNT_NAME:?}.blob.core.windows.net/${CONTAINER_NAME:?}"
container_path="${CONTAINER_PATH}"

# Login service principal
AZCOPY_SPA_CLIENT_SECRET="${AZURE_CLIENT_SECRET:?}" azcopy login \
  --service-principal \
  --tenant-id "${AZURE_TENANT_ID:?}" \
  --application-id "${AZURE_CLIENT_ID:?}"

# Silently try to create container.
azcopy make "${container_url}" || :

# Sync sucks, it cannot follow symlinks!

# There's only two supported ways to use a wildcard character in a URL.
# - You can use one just after the final forward slash (/) of a URL. This copies all of the files in a directory directly to the destination without placing them into a subdirectory.
# - You can also use one in the name of a container as long as the URL refers only to a container and not to a blob. You can use this approach to obtain files from a subset of containers.

azcopy copy \
  --recursive \
  --follow-symlinks \
  --overwrite "$AZCOPY_OVERWRITE" \
  "${UPLOAD_SOURCE}/*" \
  "${container_url}/${container_path}"
