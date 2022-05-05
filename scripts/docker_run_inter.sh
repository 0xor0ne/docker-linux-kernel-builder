#!/usr/bin/env bash

#
# docker-linux-kernel-builder
# Copyright (C) 2022  0xor0ne
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# this program. If not, see <https://www.gnu.org/licenses/>.

# Get script actual directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
ROOT_DIR=${SCRIPT_DIR}/..
source ${SCRIPT_DIR}/common.sh
source_env

DOCKFILE=${ROOT_DIR}/Dockerfile

BID=`get_builder_id ${ROOT_DIR}/${ID_FILE}`
VOLN="${DOCKER_VOL_NAME}-${BID}"

IS_RUNNING=$(docker ps --format '{{.Names}}' | \
  grep ${DOCKER_CONTAINER_NAME}-${BID})

args="/bin/bash"
if [ ! "$1" = "" ] ; then
  args="$@"
fi

if [ "${IS_RUNNING}" != "${DOCKER_CONTAINER_NAME}-${BID}" ] ; then
  docker run -it --rm \
    --name ${DOCKER_CONTAINER_NAME}-${BID} \
    --mount "type=volume,src=${VOLN},dst=/home/${DOCKER_USER}/${VOLUME_DEST}" \
    -v ${ROOT_DIR}/shared:${SHARED_DIR} \
    ${DOCKER_IMG_NAME}-${BID} \
    ${args}
else
  docker exec -it \
    ${DOCKER_CONTAINER_NAME}-${BID} \
    "$@"
fi

exit 0
