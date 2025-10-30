TrustBox is a secure communication edge device by Scalys based on NXP LS1012A processor.


# Download

This BSP is organized using git submodules. To fetch latest BSP version use command:
```
$ git clone --recursive https://github.com/Scalys/bsp-yocto.git -b scarthgap
```

# Environment

BSP build was verified to work on Ubuntu 20.04. For a reference build environment
please look at docker/.

# Docker environment

This BSP was verified with a Ubuntu 20.04 build envrionment. It is provided with this BSP and can be run with:

```
$ ./docker/run.sh
```

# Build

To build image first go into the BSP sources directory and source the environment script:
```
$ cd <bsp-location>
$ source trustbox-env
```

Then build image either for SD card/USB stick/SSD driver with:
```
$ bitbake scalys-base-image
```

Or the version for deployment on the internal QSPI flesh memory:
```
$ bitbake scalys-base-image-qspi
```

Once build completes, all the built images will be availabe at <BSP>/build/tmp/deploy/images/trustbox-edge-101

## Build with Azure IoT Edge

If IoT Edge toolset it needed, enable it by adding:

```
IMAGE_INSTALL_append = " aziot-edged"
```

to build/conf/local.conf


# Deploy

The root filesystem image contains flash-fw.scr and firmware.bin under the /boot directory.

firmware.bin is the composite image (BL2 + FIP (ATF + U-Boot + Device tree) + PFE) at fixed offsets, so that all firmare is flashed at once.

QSPI layout:
- BL2 starts at 0x0 (0 MiB)
- FIP starts at 0x00100000 (1 MiB)
- PFE starts at 0x00A00000 (10 MiB)

## Flash procedure

1. Power on the Grapeboard and stop the boot process at the bootloader stage.
2. Run these commands in order to execute the firmware flashing script:
```
=> sf probe
=> ext4load mmc 0:1 ${load_addr} /boot/flash-fw.scr
=> source ${load_addr}
```

The script loads /boot/firmware.bin, erases the required space on QSPI and writes frimware.bin to the offset 0x0.

3. Reset the environment to default:
```
=> reset
<once again stop boot during countdown>
=> env default -a
=> saveenv
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

