#!/bin/bash -e
#export DEFCONFIG=lothars__nios2_defconfig
export MY_HOME=/home/$(whoami)

sudo chown $(whoami):$(whoami) -R ${MY_HOME}/buildroot/dl
sudo chown $(whoami):$(whoami) -R ${MY_HOME}/buildroot/output

cd ${MY_HOME}/buildroot
echo "TODO"
#make ${DEFCONFIG}
#make -j8
