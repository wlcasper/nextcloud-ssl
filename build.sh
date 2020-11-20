#!/bin/bash

VERSION=${1:-latest}

docker build -t netcasper/nextcloud-ssl:${VERSION}-apache-ssl .
docker push netcasper/nextcloud-ssl:${VERSION}-apache-ssl
docker service update --image netcasper/nextcloud-ssl:${VERSION}-apache-ssl nextcloud_app
