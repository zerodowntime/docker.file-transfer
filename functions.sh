# This file must be used with "source /opt/functions.sh" *from bash*
# you cannot run it directly

# Checks if env variable exists and is set to not-null value.
# For env named FOOBAR look ups are following:
# 1) if env FOOBAR is not empty, we're good to go!
# 2) if env FOOBAR_FILE is not empty, contents of that file is taken as value
# 3) if env FOOBAR_COMMAND is not empty, output of that command is taken as value
# 4) if second paremeter is set, it is taken as value no matter if empty or not!
# 5) fails otherwise

ensure-env() {
  local env="$1"
  local val
  if [ -n "${!env}" ]; then
    return 0
  fi
  local fileenv="${env}_FILE"
  if [ -n "${!fileenv}" ]; then
    val=$(cat "${!fileenv}")
    export "$env=$val"
    return 0
  fi
  local cmdenv="${env}_COMMAND"
  if [ -n "${!cmdenv}" ]; then
    val=$(eval "${!cmdenv}")
    export "$env=$val"
    return 0
  fi
  if [ -n "$UPLOAD_SECRETS_DIR" ] && [ -f "$UPLOAD_SECRETS_DIR/$env" ]; then
    val=$(cat "$UPLOAD_SECRETS_DIR/$env")
    export "$env=$val"
    return 0
  fi
  if [ $# -eq 2 ]; then
    export "$env=$2"
    return 0
  fi
  >&2 echo "${env} is not set."
  return 1
}
