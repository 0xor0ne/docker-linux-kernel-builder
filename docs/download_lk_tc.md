# Linux Kernel Source and Toolchain download

Edit file `config.env` and set the following two variables:

- LK_DOWNLOAD_LINK: set to url where the Linux Kernel source archive will be
  downloaded from;
- TC_DOWNLOAD_LINK: set to url where the cross-compilation toolchain will be
  downloaded from;

Download both the linux kernel source and the toolchain by running the following
command:

```bash
  ./scripts/download_lk_tc.sh
```

## Linux Kernel Link Examples (LK_DOWNLOAD_LINK)

The following are example of download URLs for LTS Linux Kernel sources
available on [kernel.org](https://kernel.org/)

- 5.15.37: `https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.37.tar.xz`
- 5.10.113: `https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.10.113.tar.xz`
- 5.4.191: `https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.4.191.tar.xz`

## Toolchain Link Examples (TC_DOWNLOAD_LINK)

The following are example of download URLs for various toolchains made available
by [Bootlin](https://toolchains.bootlin.com/)

- arm64 (aarch64): `https://toolchains.bootlin.com/downloads/releases/toolchains/aarch64/tarballs/aarch64--glibc--stable-2021.11-1.tar.bz2`
- arm: `https://toolchains.bootlin.com/downloads/releases/toolchains/armv7-eabihf/tarballs/armv7-eabihf--glibc--stable-2021.11-1.tar.bz2`
- mips: `https://toolchains.bootlin.com/downloads/releases/toolchains/mips32/tarballs/mips32--glibc--stable-2021.11-1.tar.bz2`
- x86_64: `https://toolchains.bootlin.com/downloads/releases/toolchains/x86-64/tarballs/x86-64--glibc--stable-2021.11-5.tar.bz2`
