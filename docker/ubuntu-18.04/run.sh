#!/bin/bash

UTIL_NAME=$(basename "$0")

usage() {
	cat <<EOF
$UTIL_NAME CONTAINER_NAME HOST_NAME
Create a trustbox builder container with specified container and host names.
Current directory would be assumed a working directory.
EOF
}

if [ "$1" = "-h" -o "$1" = "--help" ]; then
	usage
	exit
fi

if [ $# -lt 2 ]; then
	usage >& 2
	exit 1
fi

CONTAINER="$1"
HOST="$2"

docker ps -a --format "{{.Names}}" | grep -q "^$CONTAINER$" && {
	echo "Warning: container with such name already exists. Aborting..." >& 2
	exit 1
}

docker run -t -i -h "$HOST" --net=host --name="$CONTAINER" -v $HOME:$HOME -v /lib/modules:/lib/modules --add-host "$HOST:127.0.0.1" -w $PWD "trustbox-builder-18.04" /bin/bash

