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

# Generate nuew builder ID if required
if [ "$(cat ${ROOT_DIR}/${ID_FILE})" == "default" -o \
      ! -f ${ROOT_DIR}/${ID_FILE} ] ; then
  TMP=`generate_builder_id`
  echo -n ${TMP} > ${ROOT_DIR}/${ID_FILE}
fi

BID=`get_builder_id ${ROOT_DIR}/${ID_FILE}`

VOLN="${DOCKER_VOL_NAME}-${BID}"

# remove existing volume
echo "Removing ${VOLN}"
docker volume rm ${VOLN}

echo "Creating ${VOLN}"
docker volume create --name ${VOLN}

cat <<EOF > .dfn
FROM scratch 
CMD
EOF

echo "Making a new null image"
docker build -t null -f .dfn .
docker container create --name empty -v ${VOLN}:/${VOLUME_DEST} null

echo "Copying ${ROOT_DIR}/files/${LK_ARCHIVE_NAME} to /${VOLUME_DEST}"
docker cp ${ROOT_DIR}/files/${LK_ARCHIVE_NAME} empty:/${VOLUME_DEST}
echo "Copying ${ROOT_DIR}/files/${TC_ARCHIVE_NAME} to /${VOLUME_DEST}"
docker cp ${ROOT_DIR}/files/${TC_ARCHIVE_NAME} empty:/${VOLUME_DEST}
touch .init
docker cp .init empty:/${VOLUME_DEST}

echo "Removing null image"
docker rm empty
docker rmi null

rm .dfn
rm .init

cat <<EOF > ${ROOT_DIR}/scripts/lkbuilder_env
WSDIR=/home/${DOCKER_USER}/${VOLUME_DEST}
LKB_ARCHIVES_DIR=${LKB_ARCHIVES_DIR}
LKB_KERNEL_DIR=${LKB_KERNEL_DIR}
LKB_KERNEL_SRC_DIR=${LKB_KERNEL_SRC_DIR}
LKB_KERNEL_BUILD_DIR=${LKB_KERNEL_BUILD_DIR}
LKB_KERNEL_INSTALL_DIR=${LKB_KERNEL_INSTALL_DIR}
LKB_TOOLCHAIN_DIR=${LKB_TOOLCHAIN_DIR}
LKB_TC_ARCHIVE=${TC_ARCHIVE_NAME}
LKB_LK_ARCHIVE=${LK_ARCHIVE_NAME}
LKB_SHARED_DIR=${SHARED_DIR}
LKB_MAKE_J=${LK_MAKE_J}
LKB_ARCH=${LK_ARCH}
EOF
