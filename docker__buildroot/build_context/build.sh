#!/bin/sh -e

MY_USER="$(whoami)"
MY_HOME="$(pwd)"
SSH_DIR="${MY_HOME}/.ssh"
SSH_KNOWN_HOSTS="${SSH_DIR}/known_hosts"
CONFIGS_DIR="${MY_HOME}/configs"
BR_DIR="${MY_HOME}/buildroot"

BR_DEFCONFIG=lothars__nios2_defconfig

## permissions
for item in "${BR_DIR}" "${SSH_DIR}" "${MY_HOME}/.gitconfig" "${CONFIGS_DIR}"; do
    if [ ! "${MY_USER}" = "$( stat -c %U "${item}" )" ]; then
        ## may take some time
        sudo chown "${MY_USER}:${MY_USER}" -R "${item}"
    fi
done

## ssh known_hosts
touch "${SSH_KNOWN_HOSTS}"
for item in "github.com" "bitbucket.org"; do
    if [ "" = "$( grep "${item}" -r "${SSH_KNOWN_HOSTS}" )" ]; then
        ssh-keyscan "${item}" >> "${SSH_KNOWN_HOSTS}"
    fi
done

## initial clone
FIRST="$(ls -A "${BR_DIR}"/ )"
if [ -z "${FIRST}" ]; then
    cd "${MY_HOME}"
    git clone -j4 --depth=1 --branch lothar/2020.05.x-nios2 https://github.com/Rubusch/buildroot.git buildroot
    ## alternatively get official buildrooot


    ## toolchain: code sourcery
    ## (code sourcery toolchain will be downloaded by buildroot)
    ##
    ## "Source TAR" (installer is not supposed to work, read preamble), most
    #	releases don't publish a .bin file!!!
    #wget https://sourcery.mentor.com/GNUToolchain/package15987/public/nios2-linux-gnu/sourceryg++-2020.08-3-nios2-linux-gnu.src.tar.bz2
    #tar xjf sourceryg++-2020.08-3-nios2-linux-gnu.src.tar.bz2
    #chmod a+x "${MY_HOME}/sourceryg++-2020.08-3-nios2-linux-gnu/sourceryg++-2020.08-3-nios2-linux-gnu.sh

    ## ".bin file"
    #TOOLCHAIN="sourceryg++-2018.05-5-nios2-linux-gnu.bin"
    #wget https://sourcery.mentor.com/GNUToolchain/package15406/public/nios2-linux-gnu/${TOOLCHAIN}
    #chown $USER:$USER -R /home/$USER/${TOOLCHAIN}
    #chmod a+x /home/$USER/${TOOLCHAIN}


    ## "advanced TAR" (binary tarball)
    #wget https://sourcery.mentor.com/GNUToolchain/package15404/public/nios2-linux-gnu/sourceryg++-2018.05-5-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
    #tar xjf sourceryg++-2018.05-5-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
    #cp -arf /home/$USER/sourceryg++-2018.05/* /usr/local/
    #chown $USER:$USER -R /usr/local
    #rm -f /home/$USER/sourceryg++-2018.05-5-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
    #rm -rf /home/$USER/sourceryg++-2018.05

    ## NOTE: buildroot (2020.x) downloads specific code sourcery toolchain
    ## NOTE: buildroot (2020.x) downloads specific u-boot
    ## NOTE: buildroot (2020.x) downloads specific kernel
fi



## buildroot defconfig
test -f "${CONFIGS_DIR}/${BR_DEFCONFIG}" && cp "${CONFIGS_DIR}/${BR_DEFCONFIG}" "${BR_DIR}/configs/"


cd "${BR_DIR}"
make defconfig "${BR_DEFCONFIG}"
make -j8

## kernel
echo "kernel: TODO"

## u-boot
echo "u-boot: TODO"

echo "READY."
echo
