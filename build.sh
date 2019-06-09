#!/bin/bash

imagem='adelsoncouto/vscode'
versao='1.2.1'

ok=$(docker images --format "{{.Repository}}:{{.Tag}}"| grep -o "$imagem:$versao[^-]" | wc -l)

if [[ $(echo "$versao" | sed -r 's/[^a-z]//g') = 'rc' ]]; then
  ok=0
fi

if [[ $ok -lt 1 ]]; then
  docker build -t $imagem:$versao .
fi

cd ~

container_name='vscode'
container_ip='120'


if [[ -n "$1" ]]; then
  container_name="$1"
fi

if [[ -n "$2" ]]; then
  container_ip="$2"
fi

#  --memory=4G \
docker run -it --rm \
  --hostname $container_name \
  --name $container_name \
  --net br_172_20_10 \
  --ip 172.20.10.$container_ip \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY \
  -e TERM='xterm-256color' \
  -e USER_ID=1000 \
  -e USER_NAME=adelson \
  -e USER_FULL='Adelson Silva Couto' \
  $imagem:$versao
