#!/bin/sh

exec docker run --rm -it -v "$(pwd):/workdir" crops/poky:ubuntu-20.04 --workdir=/workdir
