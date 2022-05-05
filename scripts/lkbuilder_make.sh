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

source /lkbuilder_env
source ${WSDIR}/lkbuilder_env

LK_SRC_DIR=${WSDIR}/${LKB_KERNEL_DIR}/${LKB_KERNEL_SRC_DIR}
LK_BLD_DIR=${WSDIR}/${LKB_KERNEL_DIR}/${LKB_KERNEL_BUILD_DIR}
LK_INS_DIR=${WSDIR}/${LKB_KERNEL_DIR}/${LKB_KERNEL_INSTALL_DIR}

pushd ${PWD}

cd ${LK_SRC_DIR}

TC_PREFIX=`find ${WSDIR}/${LKB_TOOLCHAIN_DIR}/bin -name "*-gcc" -print | \
  rev | cut -d '/' -f 1 | rev | sed 's/\(^.*\)gcc/\1/' | head -1`

echo "ARCH=${LKB_ARCH}"
echo "CROSS_COMPILE=${TC_PREFIX}"
echo "INSTALL_PATH=${LK_INS_DIR}"
echo "INSTALL_MOD_PATH=${LK_INS_DIR}"
echo "INSTALL_HDR_PATH=${LK_INS_DIR}"
echo "O=${LK_BLD_DIR}"

exec make \
  -j ${LKB_MAKE_J} \
  ARCH="${LKB_ARCH}" \
  CROSS_COMPILE="${TC_PREFIX}" \
  INSTALL_PATH="${LK_INS_DIR}" \
  INSTALL_MOD_PATH="${LK_INS_DIR}" \
  INSTALL_HDR_PATH="${LK_INS_DIR}" \
  O="${LK_BLD_DIR}" \
  "$@"

popd


