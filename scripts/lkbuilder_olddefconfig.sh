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

LK_BLD_DIR=${WSDIR}/${LKB_KERNEL_DIR}/${LKB_KERNEL_BUILD_DIR}

if [ ! -f ${LKB_SHARED_DIR}/.config ] ; then
  echo "No .config file in ${LKB_SHARED_DIR}"
  exit 1
fi

cp ${LKB_SHARED_DIR}/.config ${LK_BLD_DIR}

lkbuilder_make.sh olddefconfig

