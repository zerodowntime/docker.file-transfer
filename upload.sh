#!/bin/bash -e

source "${BASH_SOURCE%/*}/functions.sh"

if [ -n "$UPLOAD_SECRETS_DIR" ] && [ -d "$UPLOAD_SECRETS_DIR" ]; then
  for f in $UPLOAD_SECRETS_DIR/*; do
    [ -f "$f" ] || continue
    env=$(basename $f)
    val=$(cat $f)
    export "$env=$val"
  done
fi

ensure-env UPLOAD_STORAGE

case ${UPLOAD_STORAGE:?} in
  azcopy) /opt/azcopy.sh ;;
  azure)  /opt/azcopy.sh ;;
  dummy)  >&2 echo "Not uplading, hope you know what you doing." ;;
  *)      >&2 echo "Unknown UPLOAD_STORAGE=$UPLOAD_STORAGE" ;;
esac

echo "UPLOAD DONE!"
