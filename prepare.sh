#!/usr/bin/env bash

MOSQUITTO_RELEASES=`curl --silent "https://registry.hub.docker.com/v1/repositories/eclipse-mosquitto/tags"  | jq -r .[].name | sort | tr '\n' ' '`
PMOSCODE_RELEASES=`curl --silent "https://hub.docker.com/v2/repositories/pmoscode/mosquitto-env/tags?page_size=1024" | jq -r .results[].name | sort | tr '\n' ' '`

MOSQUITTO_RELEASES_ARRAY=("${MOSQUITTO_RELEASES}")
PMOSCODE_RELEASES_ARRAY=("${PMOSCODE_RELEASES}")

echo eclipse mosquitto versions: ${MOSQUITTO_RELEASES_ARRAY}
echo pmoscode versions: ${PMOSCODE_RELEASES_ARRAY}

# Remove duplicates from 'MOSQUITTO_RELEASES_ARRAY'...
for versions in ${PMOSCODE_RELEASES_ARRAY[@]}; do
    MOSQUITTO_RELEASES_ARRAY=( "${MOSQUITTO_RELEASES_ARRAY[@]/$versions}" )
done

echo " "
echo Umtagged versions: ${MOSQUITTO_RELEASES_ARRAY[@]}
echo " "

for value in ${MOSQUITTO_RELEASES_ARRAY}
do
    echo Tagging version: ${value}
    git tag -a ${value} -m "New Version $value"; git push https://oauth2:${REPO_ACCESS_TOKEN}@gitlab.com/pmoscodegrp/mosquitto-env.git HEAD:master --tags
done
