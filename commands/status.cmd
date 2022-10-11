#!/usr/bin/env bash
[[ ! ${WARDEN_DIR} ]] && >&2 echo -e "\033[31mThis script is not intended to be run directly!\033[0m" && exit 1

docker=$(which docker || true)

if [[ -z "${docker}" ]]; then
    echo -e "🛑 \033[31mDocker does not appear to be installed or is not available in your \$PATH.\033[0m"
    exit 1
fi

dockerVersion=$(docker version -f '{{.Server.Version}}')
dockerComposeVersion=$(docker compose version --short)

denNetworkName=$(cat ${WARDEN_DIR}/docker/docker-compose.yml | grep -A3 'networks:' | tail -n1 | sed -e 's/[[:blank:]]*name:[[:blank:]]*//g')
denNetworkId=$(docker network ls -q --filter name="${denNetworkName}")

if [[ -z "${denNetworkId}" ]]; then
    echo -e "🛑 \033[31mDen is not currently running.\033[0m Run \033[36mden svc up\033[0m to start Den core services."
    exit 0
fi

denTraefikId=$(docker container ls --filter network="${denNetworkId}" --filter status=running --filter name=traefik -q)

denTraefikNetworks=$(docker container inspect "${denTraefikId}")
projectList=$(echo "$denTraefikNetworks" | \
    python3 -c "import json, sys; [print(''.join(name.rsplit('_default',1))) for name in sorted(json.load(sys.stdin)[0]['NetworkSettings']['Networks'].keys()) if name != '${denNetworkName}' ]")

# echo ""
echo -e "Found the following \033[32mrunning\033[0m environments:"
for project in $projectList; do
    projectContainer=$(docker network inspect "${project}_default" | \
        python3 -c "import sys, json; print([container['Name'] for container in json.load(sys.stdin)[0]['Containers'].values() if container['Name'].startswith('${project}-')][0])")
    projectDir=$(docker container inspect --format '{{ index .Config.Labels "com.docker.compose.project.working_dir"}}' "$projectContainer")

    projectType=$(cat "${projectDir}/.env" | grep '^WARDEN_ENV_TYPE=' | sed -e 's/WARDEN_ENV_TYPE=[[:space:]]*//g' | tr -d -)

    echo -e "    - \033[1;35m${project}\033[0m a \033[36m${projectType}\033[0m project; located at \033[33m${projectDir}\033[0m"
done