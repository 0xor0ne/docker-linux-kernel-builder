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

pushd ${PWD}

if [ -f "${WSDIR}/.init" ] ; then
  echo "First time running..."
  sudo chown -R $(whoami):$(whoami) ${WSDIR}
  cd ${WSDIR}

  mkdir ${LKB_ARCHIVES_DIR}
  mv ${LKB_LK_ARCHIVE} ${LKB_ARCHIVES_DIR}
  mv ${LKB_TC_ARCHIVE} ${LKB_ARCHIVES_DIR}

  mkdir ${LKB_KERNEL_DIR}
  mkdir ${LKB_KERNEL_DIR}/${LKB_KERNEL_SRC_DIR}
  mkdir ${LKB_KERNEL_DIR}/${LKB_KERNEL_BUILD_DIR}
  mkdir ${LKB_KERNEL_DIR}/${LKB_KERNEL_INSTALL_DIR}
  mkdir ${LKB_TOOLCHAIN_DIR}

  echo "Extracting Linux kernel sources in ${LKB_KERNEL_DIR}/${LKB_KERNEL_SRC_DIR}"
  tar xf ${LKB_ARCHIVES_DIR}/${LKB_LK_ARCHIVE} -C ${LKB_KERNEL_DIR}/${LKB_KERNEL_SRC_DIR} --strip-components 1

  echo "Extracting toolchain in ${LKB_TOOLCHAIN_DIR}"
  tar xf ${LKB_ARCHIVES_DIR}/${LKB_TC_ARCHIVE} -C ${LKB_TOOLCHAIN_DIR} --strip-components 1

  echo "Moving lkbuilder_env to $(pwd)"
  cp /lkbuilder_env .

  rm .init
fi

popd

exec "$@"

