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

From debian:stable-slim@sha256:1086096bcb743c4d04ad1edc0fe729fe536442049d76894172c8ed1fdbb4a48b

LABEL description="Container with everything needed to cross-compile the linux kernel"

ARG user=lkb
ARG root_password=password
ARG workspace_dir=workspace
ARG tc_dir=/home/lkb/workspace/tc

# Setup environment
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends \
      build-essential \
      ncurses-dev \
      kmod \
      jfsutils \
      reiserfsprogs \
      xfsprogs \
      pcmciautils \
      quota \
      ppp \
      libgmp-dev \
      libmpc-dev \
      btrfs-progs \
      squashfs-tools \
      bc \
      git \
      flex \
      bison \
      locales \
      libssl-dev \
      vim \
      rsync \
      sudo

# Enable UTF-8 locale
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
  /usr/sbin/locale-gen

# Set root password
RUN echo "root:${root_password}" | chpasswd

# Add user
RUN useradd -ms /bin/bash ${user} && \
  chown -R ${user}:${user} /home/${user}
RUN echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY ./scripts/lkbuilder_entrypoint.sh /usr/local/bin
COPY ./scripts/lkbuilder_make.sh /usr/local/bin
COPY ./scripts/lkbuilder_olddefconfig.sh /usr/local/bin
COPY ./scripts/lkbuilder_transfer_artifacts.sh /usr/local/bin
RUN chown -R ${user}:${user} /usr/local/bin/lkbuilder_*.sh
COPY ./scripts/lkbuilder_env /
RUN chown -R ${user}:${user} /lkbuilder_env

RUN mkdir ${workspace_dir} && chown -R ${user}:${user} ${workspace_dir}

# Creating softlink to toolchain
RUN sudo ln -s ${tc_dir} /opt/tc


USER ${user}
WORKDIR /home/${user}/
ENV LC_ALL en_US.UTF-8
ENV TERM xterm-256color
ENV PATH="/opt/tc/bin:${PATH}"
ENTRYPOINT ["lkbuilder_entrypoint.sh"]

#CMD ["/bin/bash"]

