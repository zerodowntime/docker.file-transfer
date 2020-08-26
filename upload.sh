#!/bin/bash -e

source "${BASH_SOURCE%/*}/functions.sh"

ensure-env UPLOAD_STORAGE

case ${UPLOAD_STORAGE:?} in
  azcopy) /opt/azcopy.sh ;;
  azure)  /opt/azcopy.sh ;;
  dummy)  >&2 echo "Not uplading, hope you know what you doing." ;;
  *)      >&2 echo "Unknown UPLOAD_STORAGE=$UPLOAD_STORAGE" ;;
esac

echo "UPLOAD DONE!"
