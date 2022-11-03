#!/usr/bin/env bash
[[ ! ${WARDEN_DIR} ]] && >&2 echo -e "\033[31mThis script is not intended to be run directly!\033[0m" && exit 1

function sourceCustomCommands {
  SOURCE_PATH="${2}"
  SOURCE_NAME="${1}"

  echo "Sourcing ${SOURCE_PATH}"

  if [[ -n "${WARDEN_ENV_PATH}" && -d "${SOURCE_PATH}" ]]; then
    CUSTOM_COMMAND_LIST=$(ls "${SOURCE_PATH}/"*.cmd)

    if [[ -n "${CUSTOM_COMMAND_LIST}" ]]; then
      TRIM_PREFIX="${SOURCE_PATH}/"
      TRIM_SUFFIX=".cmd"
      CUSTOM_COMMANDS=""
      for COMMAND in $CUSTOM_COMMAND_LIST; do
        COMMAND=${COMMAND#"$TRIM_PREFIX"}
        COMMAND=${COMMAND%"$TRIM_SUFFIX"}
        [[ ! -e "${TRIM_PREFIX}${COMMAND}.help" ]] && continue;
        CUSTOM_COMMANDS="${CUSTOM_COMMANDS}  ${COMMAND}"$'\n'
      done

      if [[ -n "${CUSTOM_COMMANDS}" ]]; then
        CUSTOM_ENV_COMMANDS=$'\n\n'"\033[33mCustom Commands For ${SOURCE_NAME}\033[33m:\033[0m"
        CUSTOM_ENV_COMMANDS="$CUSTOM_ENV_COMMANDS"$'\n'"$CUSTOM_COMMANDS"
        WARDEN_USAGE=$(cat <<EOF
${WARDEN_USAGE}${CUSTOM_ENV_COMMANDS}
EOF
)
      fi
    fi
  fi
}

## load usage info for the given command falling back on default usage text
if [[ -f "${WARDEN_CMD_HELP}" ]]; then
  source "${WARDEN_CMD_HELP}"
else
  WARDEN_ENV_PATH="$(locateEnvPath)" || true
  source "${WARDEN_DIR}/commands/usage.help"
  sourceCustomCommands "Your PC" "${WARDEN_HOME_DIR}/commands"
  sourceCustomCommands "Environment (deprecated) \033[35m${WARDEN_ENV_PATH##*/}" "${WARDEN_ENV_PATH}/.warden/commands"
  sourceCustomCommands "Environment \033[35m${WARDEN_ENV_PATH##*/}" "${WARDEN_ENV_PATH}/.den/commands"
fi

echo -e "${WARDEN_USAGE}"
exit 1
