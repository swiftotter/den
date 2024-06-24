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
    ENV_DATA=$(magento-cloud var --columns=Name --level=environment --no-header --format=csv --project=$PROJECT --environment=$ENVIRONMENT)
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
            VAR=$(magento-cloud vget --property=value --level=environment --project=$PROJECT --environment=$ENVIRONMENT $LINE)
            LINE=$(echo $LINE | sed 's/env://g')
            echo "      $LINE: '$VAR'" >> .warden/warden-env.yml
        fi
    done
}

while true; do
    read -p $'\033[32mDo you want to import the Environment variables from '"$ENVIRONMENT"$'? y/n\033[0m ' resp
    case $resp in
      [Yy]*)
            echo "Saving enviroment variables in .warden/warden-env.yml";
            getEnvironmentVariables
            break;;
      [Nn]*) exit;;
      *) echo "Please answer (y)es or (n)o";;
    esac
done
