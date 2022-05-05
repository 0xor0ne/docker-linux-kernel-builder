# Docker (based) Linux Kernel Builder

Docker image for cross-compiling the Linux kernel.

Check the [requirements](./docs/prerequisites.md) before proceeding.

## Initial Setup

### Linux kernel Source Code and Toolchain

Put the archives containing the Linux Kernel source code and the toolchain in
the `files` directory.

Here is an example showing how to download Linux Kernel 3.15.37 from
[kernel.org](https://kernel.org/) and a toolchain provided by
[Bootlin](https://toolchains.bootlin.com/) for arm64 architecture.

```bash
  curl --output files/kernel.tar.xz https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.37.tar.xz
  curl --output files/toolchain.tar.bz2 https://toolchains.bootlin.com/downloads/releases/toolchains/aarch64/tarballs/aarch64--glibc--stable-2021.11-1.tar.bz2
```

See the [documentation](./docs/download_lk_tc.md) for more examples and an
automated way to download both the Kernel source code and the toolchain.

### Variables Setup

Edit file `config.env` and modify the following variables:

- LK_ARCHIVE_NAME: name of the archive containing the Linux Kernel source code
  placed in `files` directory;
- TC_ARCHIVE_NAME: name of the archive containing the toolchain placed in
  `files` directory;
- LK_ARCH: name of the target architecture (must match the used toolchain).
  Examples are `arm`, `arm64` and `mips`

## Building the Docker Image

Building the Docker image is a two steps process. At first, a permanent volume
containing both the toolchain and the kernel source code must be
created with:

```bash
  ./scripts/docker_create_volume.sh
```

Then, the actual Docker image can be built with:

```bash
  ./scripts/docker_build.sh
```

## Configuring and Building the Linux Kernel

It is possible to invoke any available make target on the kernel source code by
using the script `scripts/make.sh`. For example, the following command will
print the kernel make help message:

```bash
  ./scripts/make.sh help
```

NOTE: the first time the container is executed it will take more time because a
script will take care of extracting the kernel source code and the toolchain
contained in the permanent volume.

### Configuration

The kernel can be configured as usual. Here are a few examples:

- Use the default configuration for the target architecture:

```bash
  ./scripts/make.sh defconfig
```

- Configure the kernel manually using a menu based program:

```bash
  ./scripts/make.sh menuconfig
```

- Use an existing configuration: save the existing configuration in
  `shared/.config` and then run:

```bash
  ./scripts/make_olddefconfig.sh
```

- Configure the tiniest possible kernel for the target architecture (with this
  configuration kernel modules are usually disabled):

```bash
  ./scripts/make.sh tinyconfig
```


### Kernel Build

Build the kernel with:

```bash
  ./scripts/make_all_install_retrieve.sh
```

at the end of the build process, the output artifacts will be placed in
`shared/install`. Here you will find the kernel image (`vmlinux`), the symbol
table (`System.map`), the used configuration, the kernel headers (in `include`
directory) and the kernel modules (in `lib` directory).

### Cleaning Kernel Build

The kernel build directory can be cleaned as usual using the `clean` target or
the `mrproper` target (for removing also the configuration file). E.g.,

```bash
  ./scripts/make.sh mrproper
```

## Reset Docker Image and Volume

In order to start from scratch (remove the permanent volume, the Docker
image and the content of `shared` directory), you can remove everything with:

```bash
  ./scripts/docker_remove_all.sh
```

## TODOs

- Add script for building out-of-tree kernel modules;
- Add support for building Busybox for quick testing in Qemu;
  - [see here](https://mgalgs.io/2021/03/23/how-to-build-a-custom-linux-kernel-for-qemu-using-docker.html)
- Add support for [building the kernel with CLANG](https://www.kernel.org/doc/html/latest/kbuild/llvm.html#);
- Add support for building experimental Rust based kernel modules.

