#!/bin/bash -e

export DEFCONFIG=lothars__nios2_defconfig
export MY_HOME=/home/$(whoami)

## buildroot
[[ -f ${MY_HOME}/configs/${DEFCONFIG} ]] && cp ${MY_HOME}/configs/${DEFCONFIG} ${MY_HOME}/buildroot/configs/

sudo chown $(whoami):$(whoami) -R ${MY_HOME}/buildroot
sudo chown $(whoami):$(whoami) -R ${MY_HOME}/buildroot/dl
sudo chown $(whoami):$(whoami) -R ${MY_HOME}/buildroot/output

cd ${MY_HOME}/buildroot
make defconfig ${DEFCONFIG}
make -j8

## kernel
echo "kernel: TODO"

## u-boot
echo "u-boot: TODO"

echo "READY."
echo
