#!/bin/bash

set -o pipefail

function start_container {
  docker run \
    --name erlangelist-graphite \
    --rm \
    -p 5455:80 \
    -p 5456:2003 \
    -p 5457:8125/udp \
    erlangelist/graphite:latest
}

function stop_container {
  for container in $(docker ps | grep "erlangelist-graphite" | awk '{print $1}'); do
    docker stop -t 2 $container > /dev/null
  done

  for container in $(docker ps -a | grep "erlangelist-graphite" | awk '{print $1}'); do
    docker rm $container > /dev/null
  done
}

case "$1" in
  start)
    start_container
    ;;

  stop)
    stop_container
    ;;

  ssh)
    docker exec -it erlangelist-graphite /bin/sh
    ;;
esac