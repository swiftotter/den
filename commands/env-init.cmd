#!/usr/bin/env bash
[[ ! ${WARDEN_DIR} ]] && >&2 echo -e "\033[31mThis script is not intended to be run directly!\033[0m" && exit 1

WARDEN_ENV_PATH="$(pwd -P)"

# Prompt user if there is an extant .env file to ensure they intend to overwrite
if test -f "${WARDEN_ENV_PATH}/.env"; then
  while true; do
    read -p $'\033[32mA warden env file already exists at '"${WARDEN_ENV_PATH}/.env"$'; would you like to overwrite? y/n\033[0m ' resp
    case $resp in
      [Yy]*) echo "Overwriting extant .env file"; break;;
      [Nn]*) exit;;
      *) echo "Please answer (y)es or (n)o";;
    esac
  done
fi

WARDEN_ENV_NAME="${WARDEN_PARAMS[0]:-}"

# If warden environment name was not provided, prompt user for it
while [ -z "${WARDEN_ENV_NAME}" ]; do
  read -p $'\033[32mAn environment name was not provided; please enter one:\033[0m ' WARDEN_ENV_NAME
done

WARDEN_ENV_TYPE="${WARDEN_PARAMS[1]:-}"

# If warden environment type was not provided, prompt user for it
if [ -z "${WARDEN_ENV_TYPE}" ]; then
  while true; do
    read -p $'\033[32mAn environment type was not provided; please choose one of ['"$(fetchValidEnvTypes)"$']:\033[0m ' WARDEN_ENV_TYPE
    assertValidEnvType && break
  done
fi

# Verify the auto-select and/or type path resolves correctly before setting it
assertValidEnvType || exit $?

# Write the .env file to current working directory
cat > "${WARDEN_ENV_PATH}/.env" <<EOF
WARDEN_ENV_NAME=${WARDEN_ENV_NAME}
WARDEN_ENV_TYPE=${WARDEN_ENV_TYPE}
WARDEN_WEB_ROOT=/

TRAEFIK_DOMAIN=${WARDEN_ENV_NAME}.test
TRAEFIK_SUBDOMAIN=app
EOF

if [[ "${WARDEN_ENV_TYPE}" == "magento1" ]]; then
  cat >> "${WARDEN_ENV_PATH}/.env" <<-EOT

		WARDEN_DB=1
		WARDEN_REDIS=1

		DB_DISTRIBUTION=mariadb
		DB_DISTRIBUTION_VERSION=10.3
		NODE_VERSION=12
		COMPOSER_VERSION=1
		PHP_VERSION=7.2
		PHP_XDEBUG_3=1
		REDIS_VERSION=5.0

		WARDEN_SELENIUM=0
		WARDEN_SELENIUM_DEBUG=0
		WARDEN_BLACKFIRE=0

		BLACKFIRE_CLIENT_ID=
		BLACKFIRE_CLIENT_TOKEN=
		BLACKFIRE_SERVER_ID=
		BLACKFIRE_SERVER_TOKEN=
	EOT
fi

if [[ "${WARDEN_ENV_TYPE}" == "magento2" ]]; then
  cat >> "${WARDEN_ENV_PATH}/.env" <<-EOT

		WARDEN_DB=1
		WARDEN_ELASTICSEARCH=1
		WARDEN_ELASTICHQ=0
		WARDEN_VARNISH=1
		WARDEN_RABBITMQ=1
		WARDEN_REDIS=1

		ELASTICSEARCH_VERSION=7.6
		DB_DISTRIBUTION=mariadb
		DB_DISTRIBUTION_VERSION=10.3
		NODE_VERSION=12
		COMPOSER_VERSION=1
		PHP_VERSION=7.4
		PHP_XDEBUG_3=1
		RABBITMQ_VERSION=3.8
		REDIS_VERSION=5.0
		VARNISH_VERSION=6.0

		WARDEN_SYNC_IGNORE=

		WARDEN_ALLURE=0
		WARDEN_SELENIUM=0
		WARDEN_SELENIUM_DEBUG=0
		WARDEN_BLACKFIRE=0
		WARDEN_SPLIT_SALES=0
		WARDEN_SPLIT_CHECKOUT=0
		WARDEN_TEST_DB=0
		WARDEN_MAGEPACK=0

		BLACKFIRE_CLIENT_ID=
		BLACKFIRE_CLIENT_TOKEN=
		BLACKFIRE_SERVER_ID=
		BLACKFIRE_SERVER_TOKEN=
	EOT
fi

if [[ "${WARDEN_ENV_TYPE}" == "laravel" ]]; then
  cat >> "${WARDEN_ENV_PATH}/.env" <<-EOT

		DB_DISTRIBUTION=mariadb
		DB_DISTRIBUTION_VERSION=10.4
		NODE_VERSION=12
		COMPOSER_VERSION=1
		PHP_VERSION=7.4
		PHP_XDEBUG_3=1
		REDIS_VERSION=5.0

		WARDEN_DB=1
		WARDEN_REDIS=1

		## Laravel Config
		APP_URL=http://app.${WARDEN_ENV_NAME}.test
		APP_KEY=base64:$(dd if=/dev/urandom bs=1 count=32 2>/dev/null | base64)

		APP_ENV=local
		APP_DEBUG=true

		DB_CONNECTION=mysql
		DB_HOST=db
		DB_PORT=3306
		DB_DATABASE=laravel
		DB_USERNAME=laravel
		DB_PASSWORD=laravel

		CACHE_DRIVER=redis
		SESSION_DRIVER=redis

		REDIS_HOST=redis
		REDIS_PORT=6379

		MAIL_DRIVER=sendmail
	EOT
fi

if [[ "${WARDEN_ENV_TYPE}" =~ ^symfony|shopware$ ]]; then
  cat >> "${WARDEN_ENV_PATH}/.env" <<-EOT

		WARDEN_DB=1
		WARDEN_REDIS=1
		WARDEN_RABBITMQ=0
		WARDEN_ELASTICSEARCH=0
		WARDEN_VARNISH=0

		DB_DISTRIBUTION=mariadb
		DB_DISTRIBUTION_VERSION=10.4
		NODE_VERSION=12
		COMPOSER_VERSION=2
		PHP_VERSION=7.4
		PHP_XDEBUG_3=1
		RABBITMQ_VERSION=3.8
		REDIS_VERSION=5.0
		VARNISH_VERSION=6.0
	EOT
fi

if [[ "${WARDEN_ENV_TYPE}" == "wordpress" ]]; then
  cat >> "${WARDEN_ENV_PATH}/.env" <<-EOT

		DB_DISTRIBUTION=mariadb
		DB_DISTRIBUTION_VERSION=10.4
		NODE_VERSION=12
		COMPOSER_VERSION=1
		PHP_VERSION=7.4
		PHP_XDEBUG_3=1

		WARDEN_DB=1
		WARDEN_REDIS=0

		APP_ENV=local
		APP_DEBUG=true

		DB_CONNECTION=mysql
		DB_HOST=db
		DB_PORT=3306
		DB_DATABASE=wordpress
		DB_USERNAME=wordpress
		DB_PASSWORD=wordpress
	EOT
fi

if [[ "${WARDEN_ENV_TYPE}" == "drupal" ]]; then
  cat >> "${WARDEN_ENV_PATH}/.env" <<-EOT

		DB_DISTRIBUTION=mariadb
		DB_DISTRIBUTION_VERSION=10.4
		NODE_VERSION=18
		COMPOSER_VERSION=2
		PHP_VERSION=8.1
		PHP_XDEBUG_3=1

		WARDEN_DB=1
		WARDEN_RABBITMQ=0
		WARDEN_REDIS=0

		RABBITMQ_VERSION=3.8
		
		WARDEN_SYNC_IGNORE=

		WARDEN_ALLURE=0
		WARDEN_SELENIUM=0
		WARDEN_SELENIUM_DEBUG=0
		WARDEN_BLACKFIRE=0

		BLACKFIRE_CLIENT_ID=
		BLACKFIRE_CLIENT_TOKEN=
		BLACKFIRE_SERVER_ID=
		BLACKFIRE_SERVER_TOKEN=
	EOT

	# If Drupal directories exist, make sure the minimum user-content upload directories exist
	if [[ -d "${WARDEN_ENV_PATH}/web/sites/default" ]] && [[ ! -d "${WARDEN_ENV_PATH}/web/sites/default/files" ]]
	then
		echo -e "\033[1;33m[!] \033[0mCreating missing user-content directory: \"\033[36m${WARDEN_ENV_PATH}/web/sites/default/files\033[0m\"."
		mkdir -p "${WARDEN_ENV_PATH}/web/sites/default/files"
	fi

	if [[ ! -d "${WARDEN_ENV_PATH}/web/sites/default/private" ]]; then
		echo -e "\033[1;33m[!] \033[0mCreating missing private user-content directory: \"\033[36m${WARDEN_ENV_PATH}/web/sites/default/private\033[0m\"."
		mkdir -p "${WARDEN_ENV_PATH}/web/sites/default/private"
		cat > "${WARDEN_ENV_PATH}/web/sites/default/private/.htaccess" <<-EOT
			# Drupal SA-CORE-2013-003
			# This file attempts to provide defense in depth to Apache servers. See
			# https://www.drupal.org/forum/newsletters/security-advisories-for-drupal-core/2013-11-20/sa-core-2013-003-drupal-core

			# Turn off all options we don't need.
			Options None
			Options +FollowSymLinks

			# Set the catch-all handler to prevent scripts from being executed.
			SetHandler Drupal_Security_Do_Not_Remove_See_SA_2006_006
			<Files *>
			# Override the handler again if we're run later in the evaluation list.
			SetHandler Drupal_Security_Do_Not_Remove_See_SA_2013_003
			</Files>

			# If we know how to do it safely, disable the PHP engine entirely.
			<IfModule mod_php5.c>
			php_flag engine off
			</IfModule>

			Deny from all
		EOT
	fi
fi
