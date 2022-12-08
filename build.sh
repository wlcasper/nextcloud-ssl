#!/bin/bash

set -e

VERSION=${1:-latest}
RESET_FACE_RECOGNITION={$2:no}

docker build -t netcasper/nextcloud-ssl:${VERSION}-apache-ssl .
docker push netcasper/nextcloud-ssl:${VERSION}-apache-ssl
docker service update --image netcasper/nextcloud-ssl:${VERSION}-apache-ssl nextcloud_app
if [ "${RESET_FACE_RECOGNITION}" != "no" ]
then
    CONTAINER_ID=nextcloud_app.1.$(docker stack ps -f 'name=nextcloud_app.1' nextcloud -q --no-trunc | head -n1)
    docker exec -ti -u www-data ${CONTAINER_ID} php occ face:reset --all
    docker exec -ti -u www-data ${CONTAINER_ID} php occ face:setup -M 4G -m 1
fi
