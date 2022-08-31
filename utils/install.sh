#!/usr/bin/env bash
[[ ! ${WARDEN_DIR} ]] && >&2 echo -e "\033[31mThis script is not intended to be run directly!\033[0m" && exit 1

function installSshConfig () {
  if ! grep '## WARDEN START ##' /etc/ssh/ssh_config >/dev/null; then
    echo "==> Configuring sshd tunnel in host ssh_config (requires sudo privileges)"
    echo "    Note: This addition to the ssh_config file can sometimes be erased by a system"
    echo "    upgrade requiring reconfiguring the SSH config for tunnel.den.test."
    cat <<-EOT | sudo tee -a /etc/ssh/ssh_config >/dev/null

			## WARDEN START ##
			Host tunnel.warden.test
			HostName 127.0.0.1
			User user
			Port 2222
			IdentityFile ~/.den/tunnel/ssh_key
			Host tunnel.den.test
			HostName 127.0.0.1
			User user
			Port 2222
			IdentityFile ~/.den/tunnel/ssh_key
			## WARDEN END ##
			EOT
  fi
  
  # Migrate from Warden to Den
  if grep "~/.warden/tunnel/ssh_key" /etc/ssh/ssh_config >/dev/null; then
      sudo sed -i.bak 's/~\/.warden/~\/.den/' /etc/ssh/ssh_config
  fi
}

function assertWardenInstall {
  if [[ ! -f "${WARDEN_HOME_DIR}/.installed" ]] \
    || [[ "${WARDEN_HOME_DIR}/.installed" -ot "${WARDEN_DIR}/bin/den" ]]
  then
    [[ -f "${WARDEN_HOME_DIR}/.installed" ]] && echo "==> Updating warden" || echo "==> Starting initialization"

    "${WARDEN_DIR}/bin/den" install

    [[ -f "${WARDEN_HOME_DIR}/.installed" ]] && echo "==> Update complete" || echo "==> Initialization complete"
    date > "${WARDEN_HOME_DIR}/.installed"
  fi

  ## append settings for tunnel.den.test in /etc/ssh/ssh_config
  #
  # NOTE: This function is called on every invocation of this assertion in an attempt to ensure
  # the ssh configuration for the tunnel is present following it's removal following a system
  # upgrade (macOS Catalina has been found to reset the global SSH configuration file)
  #

  installSshConfig
}
