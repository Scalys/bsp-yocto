TrustBox is a secure communication edge device by Scalys based on NXP LS1012A processor.

# Download

This BSP is organized using git submodules. To fetch latest BSP version use command:
```
$ git clone --recursive https://github.com/Scalys/bsp-yocto.git -b dunfell
```

# Environment

BSP build was verified to work on Ubuntu 18.04. For a reference build environment
please look at docker/.

# Docker environment

This BSP was verified with a Ubuntu 18.04 build envrionment. It is provided with this BSP and can be created with:

```
$ cd docker/ubuntu-18.04
$ make
$ cd ../..
$ ./docker/ubuntu-18.04/run.sh trustbox-builder builder
```

# Build

To build image first go into the BSP sources directory and source the environment script:
```
$ cd <bsp-location>
$ source trustbox-env
```

Note: to enable mender firmware update integration add to the generated build/conf/local.conf:
```
MENDER_FEATURES_ENABLE_append = " mender-uboot"
```
And to the build/conf/bblayers.conf:
```
...
  /home/haff/work/trustbox/bsp-yocto/sources/meta-freescale \
  /home/haff/work/trustbox/bsp-yocto/sources/meta-mender/meta-mender-core \
  /home/haff/work/trustbox/bsp-yocto/sources/meta-scalys \
...
```

Then build image either for SD card/USB stick/SSD driver with:
```
$ bitbake scalys-base-image
```

Or the version for deployment on the internal QSPI flesh memory:
```
$ bitbake scalys-base-image-qspi
```

Once build completes, all the built images will be availabe at <BSP>/build/tmp/deploy/images/trustbox


# Deploy

## U-Boot

There are two u-boot images generated by the yocto build:

- u-boot.bin-pcie
- u-boot.bin-sata

They differ in the way bootloader configures m.2 slot. Depending on the required
configuration take the needed image.

1. Put the generated u-boot image in the root of the SD card.
2. Rename it as a u-boot-with-pbl.bin
3. Power on the Grapeboard and stop the boot process at the bootloader stage.
4. Run the u-boot update scrip:
```
=> run update_mmc_uboot_qspi_nor
```
5. After update reset the environment to default
```
=> reset
<once again stop boot during countdown>
=> env default -a
=> saveenv
```

## PFE firmware

1. Place the pfe firmware engine-pfe-bin/pfe_fw_sbl.itb in the SD card root
2. Boot the trustbox and stop the boot process at the bootloader stage.
3. Run the pfe update scrip:
```
=> run update_mmc_pfe_qspi_nor
```

## PPA firmware

1. Place the ppa firmware ppa.itb in the SD card root
2. Boot the trustbox and stop the boot process at the bootloader stage.
3. Run the ppa update scrip:
```
=> run update_mmc_ppa_qspi_nor
```

## SD card root

1. Format SD card into a single ext4 partition
2. Unpack contents of the generated scalys-base-image-trustbox.tar.gz to the SD card


# Development

Development of custom applications for the Yocto-based BSP can be done via Yocto
SDK. It includes compilers, linker and all the development files for packages
configured in the scalys-base-image image. Pre-built version of this SDK is
available in a form of shell script poky-glibc-x86_64-s-tracks-image-base-aarch64-toolchain-2.5.sh.

To install it execute the script and enter SDK installation path. Once installed, source generated environment via:
```
$ source /opt/poky/2.5/environment-setup-aarch64-poky-linux
```

To build an SDK for a custom image with set of packages different from the default one:
```
$ bitbake -c populate_sdk <custom_image>
```

The resulting SDK will be located in the directory <BSP>/build/tmp/deploy/sdk.

