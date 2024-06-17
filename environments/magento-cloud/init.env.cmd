function :: {
  echo
  echo "==> [$(date +%H:%M:%S)] $@"
}

function getProjectAndEnvironment {
    if [[ -f ".magento/local/project.yaml" ]] && [[ -f ".git/HEAD" ]]; then
        PROJECT=$(cat .magento/local/project.yaml | grep id | sed "s/id: //")
        ENVIRONMENT=$(cat .git/HEAD | sed "s/ref: refs\/heads\///")
    fi

    if [ -z "$PROJECT" ]; then
        ENV_DATA=$(magento-cloud environment:info --format=csv --no-header)
        [[ $ENV_DATA =~ ^id,([^[:space:]]*) ]] && ENVIRONMENT=${BASH_REMATCH[1]}
        [[ $ENV_DATA =~ project,([a-z|A-Z|1-9]*) ]] && PROJECT=${BASH_REMATCH[1]}
    fi
}

function getPHPVersion {
    ENV_DATA=$(magento-cloud apps --format=csv --no-header --project=$PROJECT --environment=$ENVIRONMENT)
    [[ $ENV_DATA =~ php:([0-9|\.]*) ]] && PHP_VERSION=${BASH_REMATCH[1]}
}

function getDBVersion {
    ENV_DATA=$(magento-cloud services --format=csv --no-header --project=$PROJECT --environment=$ENVIRONMENT)
    if [[ $ENV_DATA =~ elasticsearch:([0-9|\.]*) ]]
    then
        ELASTICSEARCH_VERSION=${BASH_REMATCH[1]}
        ELASTICSEARCH_ENABLED=1
    else
        if [[ $ENV_DATA =~ opensearch:([0-9|\.]*) ]]
        then
            OPENSEARCH_VERSION=${BASH_REMATCH[1]}
            OPENSEARCH_ENABLED=1
        fi
    fi
    if [[ $ENV_DATA =~ mysql:([0-9|\.]*) ]]
    then
        MARIADB_VERSION=${BASH_REMATCH[1]}
    fi
    if [[ $ENV_DATA =~ redis:([0-9|\.]*) ]]
    then
        REDIS_VERSION=${BASH_REMATCH[1]}
    fi
    if [[ $ENV_DATA =~ rabbitmq:([0-9|\.]*) ]]
    then
        RABBITMQ_VERSION=${BASH_REMATCH[1]}
    fi
}

function getComposerVersion {
    ENV_DATA=$(magento-cloud -q ssh 'composer --version' --project=$PROJECT --environment=$ENVIRONMENT)
    if [[ $ENV_DATA =~ 1\.([0-9]*)\. ]]
    then
        COMPOSER_VERSION=1
    else
        COMPOSER_VERSION=2
    fi
}

function checkMagentoCloudCli {
    if ! command -v magento-cloud &> /dev/null
    then
        echo -e "\033[33mmagento-cloud-cli could not be found.\033[0m"
        exit 1
    fi
}

checkMagentoCloudCli
getProjectAndEnvironment
getPHPVersion
getDBVersion
getComposerVersion

cat .env | \
sed "s/=magento-cloud/=magento2/g" | \
sed "s/%MARIADB_VERSION%/${MARIADB_VERSION:-10.3}/g" | \
sed "s/%COMPOSER_VERSION%/${COMPOSER_VERSION:-1}/g" | \
sed "s/%PHP_VERSION%/${PHP_VERSION:-7.4}/g" | \
sed "s/%RABBITMQ_VERSION%/${RABBITMQ_VERSION:-3.8}/g" | \
sed "s/%REDIS_VERSION%/${REDIS_VERSION:-5.0}/g" | \
sed "s/%ELASTICSEARCH_ENABLED%/${ELASTICSEARCH_ENABLED:-0}/g" | \
sed "s/%ELASTICSEARCH_VERSION%/${ELASTICSEARCH_VERSION:-7.6}/g" | \
sed "s/%OPENSEARCH_ENABLED%/${OPENSEARCH_ENABLED:-0}/g" | \
sed "s/%OPENSEARCH_VERSION%/${OPENSEARCH_VERSION:-1.2}/g" | \
sed "s/%PROJECT%/${PROJECT}/g" | \
sed "s/%ENVIRONMENT%/${ENVIRONMENT}/g" > .env


function getEnvironmentVariables {
    ENV_DATA=$(magento-cloud var --columns=Name --level=environment \
        --no-header --format=csv --project=$PROJECT --environment=$ENVIRONMENT)
    ENV_DATA=$(echo "$ENV_DATA" | sort -u)
    mkdir -p .warden
    echo "version: '3.5'
services:
  php-fpm:
    environment:" > .warden/warden-env.yml

    for LINE in $ENV_DATA
    do
        if [[ $LINE =~ ^env:([a-zA-Z0-9_]+) ]]
        then
            VAR=$(magento-cloud vget --property=value \
                --level=environment --project=$PROJECT --environment=$ENVIRONMENT $LINE)
            LINE=$(echo $LINE | sed 's/env://g')
            echo "      $LINE: '$VAR'" >> .warden/warden-env.yml
        fi
    done
}

while true; do
    read -p $'\033[32mDo you want to import the Environment variables from '"$ENVIRONMENT"'? y/n'$'\033[0m ' resp
    case $resp in
      [Yy]*)
            :: Saving enviroment variables in .warden/warden-env.yml
            getEnvironmentVariables
            break;;
      [Nn]*) exit;;
      *) echo "Please answer (y)es or (n)o";;
    esac
done

function backupEnvPhpFile {
    if [[ -f "app/etc/env.php" ]]; then
        cp app/etc/env.php app/etc/env.php.bak
        :: "Backup of app/etc/env.php => app/etc/env.php.bak"
    fi
}

function detectMultiStore {
    config=$(cat ${WARDEN_DIR}/environments/magento-cloud/magento2-config.env)
    config+="
system/default/web/unsecure/base_url=https://app."${WARDEN_ENV_NAME}".test/
system/default/web/secure/base_url=https://app."${WARDEN_ENV_NAME}".test/
system/default/web/secure/offloader_header=X-Forwarded-Proto
system/default/web/secure/use_in_frontend=1
system/default/web/secure/use_in_adminhtml=1
"
    SQL=$(magento-cloud sql --project=$PROJECT --environment=$ENVIRONMENT --relationship=database \
    -q "SELECT GROUP_CONCAT(code, '@') FROM store_website WHERE is_default = 0 ORDER BY website_id ASC;" \
    | grep admin | sed 's/,//g' | sed 's/ //g' | sed 's/|//g' | sed 's/@/ /g' | sed 's/\r//g')

    storesPhp=""

    for website in $SQL; do
        if [ "$website" != "admin" ]; then
            config+="
system/websites/${website}/web/unsecure/base_url=https://${website/_/-}."${WARDEN_ENV_NAME}".test/
system/websites/${website}/web/secure/base_url=https://${website/_/-}."${WARDEN_ENV_NAME}".test/
"
            storesPhp+="    case '${website/_/-}.${WARDEN_ENV_NAME}.test':
        \$runCode = '${website}';
        \$runType = 'website';
        break;
"
        fi
    done
}

function createEnvPhpFile {
    mkdir -p app/etc
    ENV_PHP=$(magento-cloud ssh --project=$PROJECT --environment=$ENVIRONMENT php <<CODE
<?Php
        \$config = <<<CONFIG
$config
CONFIG;
        \$newConfig = require('app/etc/env.php');

        \$lines = explode("\n",\$config);
        ksort(\$lines);
        foreach (\$lines as \$line) {
            \$parts = explode('=', \$line, 2);
            if(count(\$parts) != 2) continue;

            \$path = explode('/', \$parts[0]);

            \$current = &\$newConfig;
            foreach (\$path as \$key) {
                \$current = &\$current[\$key];
                if (!is_array(\$current)) {
                    \$current = [];
                }
            }

            switch (trim(trim(\$parts[1], "'"), '"')) {
                case 'true':
                    \$current = true;
                break;
                case 'false':
                    \$current = false;
                break;
                case 'null':
                    \$current = null;
                break;
                default:
                    \$current = is_numeric(\$parts[1])?
                        (int)\$parts[1] : \$parts[1];
                break;
            }
        }

        \$export = var_export(\$newConfig, TRUE);
        \$export = preg_replace("/^([ ]*)(.*)/m", '\$1\$1\$2', \$export);
        \$array = preg_split("/\r\n|\n|\r/", \$export);
        \$array = preg_replace(["/\s*array\s\(\$/", "/\)(,)?\$/", "/\s=>\s\$/"], [NULL, ']\$1', ' => ['], \$array);
        echo join(PHP_EOL, array_filter(["["] + \$array));
?>
CODE
);
    echo "<?php
return $ENV_PHP;" > app/etc/env.php

    :: Created app/etc/env.php
}

while true; do
    read -p $'\033[32mDo you want me to import the env.php from '"$ENVIRONMENT"' and update it for Den? y/n'$'\033[0m ' resp
    case $resp in
      [Yy]*)
            backupEnvPhpFile
            detectMultiStore
            createEnvPhpFile
            break;;
      [Nn]*) exit;;
      *) echo "Please answer (y)es or (n)o";;
    esac
done

function createStoresPhpFile {
    mkdir -p app/etc
    if [[ -f "app/etc/stores.php" ]]; then
        cp app/etc/stores.php app/etc/stores.php.bak
        :: "Backup of app/etc/stores.php => app/etc/stores.php.bak"
    fi

    echo "<?php

use \Magento\Store\Model\StoreManager;
\$serverName = isset(\$_SERVER['HTTP_HOST']) ? \$_SERVER['HTTP_HOST'] : null;

switch (\$serverName) {
${storesPhp}    default:
        return;
}

if ((!isset(\$_SERVER[StoreManager::PARAM_RUN_TYPE])
        || !\$_SERVER[StoreManager::PARAM_RUN_TYPE])
    && (!isset(\$_SERVER[StoreManager::PARAM_RUN_CODE])
        || !\$_SERVER[StoreManager::PARAM_RUN_CODE])
) {
    \$_SERVER[StoreManager::PARAM_RUN_CODE] = \$runCode;
    \$_SERVER[StoreManager::PARAM_RUN_TYPE] = \$runType;
}" > app/etc/stores.php

    :: Created app/etc/stores.php for multi-store. You still need to add it to your Composer.json [autoload], please read the documentation \(https://swiftotter.github.io/den/configuration/multipledomains.html\).
}

if [ storesPhp != "" ]; then
    while true; do
        read -p $'\033[32mYour environment is a multi-store, do you want me to create app/etc/stores.php settings? y/n'$'\033[0m ' resp
        case $resp in
          [Yy]*)
                createStoresPhpFile
                break;;
          [Nn]*) exit;;
          *) echo "Please answer (y)es or (n)o";;
        esac
    done
fi
