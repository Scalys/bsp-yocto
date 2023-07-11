#!/bin/bash

set -eu

UTIL_PATH=$(readlink -f "$0")
UTIL_NAME=$(basename "$UTIL_PATH")
UTIL_DIR=$(dirname "$UTIL_PATH")

DOCKER_IMAGE="trustbox-builder"
HOST="trustbox"


usage() {
	cat <<EOF
$UTIL_NAME
Run a trustbox builder container.
Current directory would be assumed a working directory.
EOF
}

parse_arguments() {
	options=$(getopt -o h --long help: -- "$@")
	[ $? -eq 0 ] || {
		usage
		exit 1
	}
	eval set -- "$options"
	while true; do
		case "$1" in
		-h|--help) usage ; exit ;;
		--) shift ; break ;;
		esac
		shift
	done

	WORK_DIR=$(readlink -f "$UTIL_DIR"/..)
	DOCKER_DIR=$(readlink -f "$WORK_DIR/docker")
}

docker_build() {
	# Check if image already exists
	if docker image inspect "$DOCKER_IMAGE" &> /dev/null; then
		return
	else
		make
	fi
}

docker_run() {
	docker run --rm -ti -h "$HOST" --net=host -v "$WORK_DIR:$WORK_DIR" -v "$HOME/.bash_history:$HOME/.bash_history" -w "$WORK_DIR" --add-host "$HOST:127.0.0.1" "$DOCKER_IMAGE"
}


parse_arguments $@

cd "$DOCKER_DIR"

docker_build
docker_run

