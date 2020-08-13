#!/bin/bash -e

if [ -z "$UPLOAD_STORAGE" ]; then
  if [ -n "$UPLOAD_STORAGE_FILE" ]; then
    UPLOAD_STORAGE=$(cat "$UPLOAD_STORAGE_FILE")
    export UPLOAD_STORAGE
  fi
fi

case ${UPLOAD_STORAGE:?} in
  azcopy) /opt/azcopy.sh ;;
  azure)  /opt/azcopy.sh ;;
  dummy)  >&2 echo "Not uplading, hope you know what you doing." ;;
  *)      >&2 echo "Unknown UPLOAD_STORAGE=$UPLOAD_STORAGE" ;;
esac

echo "UPLOAD DONE!"
