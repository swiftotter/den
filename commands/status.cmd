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
projectNetworkList=$(docker container inspect --format '{{ range $k,$v := .NetworkSettings.Networks }}{{ if ne $k "warden" }}{{printf "%s\n" $k }}{{ end }}{{end}}' "${denTraefikId}")

echo -e "Found the following \033[32mrunning\033[0m environments:"
for projectNetwork in $projectNetworkList; do
    prefix="${projectNetwork%_default}"
    prefixLen="${#prefix}"
    ((prefixLen+=1))
    projectContainers=$(docker network inspect --format '{{ range $k,$v := .Containers }}{{ $prefix := slice $v.Name 0 '"${prefixLen}"' }}{{ if eq $prefix "'"${prefix}-"'" }}{{ println $v.Name }}{{end}}{{end}}' "${projectNetwork}")
    container=$(echo "$projectContainers" | head -n1)
    
    projectDir=$(docker container inspect --format '{{ index .Config.Labels "com.docker.compose.project.working_dir"}}' "$container")
    projectName=$(cat "${projectDir}/.env" | grep '^WARDEN_ENV_NAME=' | sed -e 's/WARDEN_ENV_NAME=[[:space:]]*//g' | tr -d -)
    projectType=$(cat "${projectDir}/.env" | grep '^WARDEN_ENV_TYPE=' | sed -e 's/WARDEN_ENV_TYPE=[[:space:]]*//g' | tr -d -)
    traefikDomain=$(cat "${projectDir}/.env" | grep '^TRAEFIK_DOMAIN=' | sed -e 's/TRAEFIK_DOMAIN=[[:space:]]*//g' | tr -d -)

    echo -e "    \033[1;35m${projectName}\033[0m a \033[36m${projectType}\033[0m project"
    echo -e "       Project Directory: \033[33m${projectDir}\033[0m"
    echo -e "       Project URL: \033[94mhttps://${traefikDomain}\033[0m"
    echo "   "
done