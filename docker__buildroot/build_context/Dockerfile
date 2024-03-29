FROM debian:10
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""


################################################################################
## set up apt fully functional
RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y --purge
RUN apt-get install -y  \
    zlib1g-dev \
    g++ \
    build-essential \
    rsync \
    binutils \
    unzip \
    python \
    bzip2 \
    locales \
    libc6-dev \
    fakeroot \
    bin86 \
    udev \
    hdparm \
    xmlto \
    tree \
    colordiff \
    sudo \
    wget \
    libc6-i386 \
    u-boot-tools \
    cpio \
    openjdk-11-jdk-headless \
    openjdk-11-jdk \
    vim \
    libncurses5-dev \
    gcc \
    make \
    git-all \
    exuberant-ctags \
    libssl-dev \
    bison \
    flex \
    libelf-dev \
    bc \
    aptitude \
    tig \
    emacs-nox \
    codespell \
    python-ply \
    python-git


################################################################################
## locale settings
RUN locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

## locale-hack, needed for debian since locale-gen <arg> seems not to work
RUN sed -i '/^#.* en_US.UTF-8.* /s/^#//' /etc/locale.gen
RUN locale-gen


################################################################################
## setup user and run stuff under user
RUN useradd "$USER" -m --password "$USER"
RUN usermod -a -G sudo "$USER"
RUN sed -i '/%sudo/s/.*/%sudo   ALL=NOPASSWD: ALL/' /etc/sudoers


################################################################################
## get (my) sources
## prepare paths

## alternatively get official buildrooot
## NB: buildroot/dl and buildroot/output will be mounted, thus may have root ownership (use chown later)
#    RUN git clone -j4 --depth=1 --branch lothar/2020.05.x-nios2 https://github.com/Rubusch/buildroot.git buildroot

## toolchain: code sourcery
## (code sourcery toolchain will be downloaded by buildroot)
##
## "Source TAR" (installer is not supposed to work, read preamble), most releases don't publish a .bin file!!!
#RUN cd /home/$USER && wget https://sourcery.mentor.com/GNUToolchain/package15987/public/nios2-linux-gnu/sourceryg++-2020.08-3-nios2-linux-gnu.src.tar.bz2
#RUN cd /home/$USER && tar xjf sourceryg++-2020.08-3-nios2-linux-gnu.src.tar.bz2
#RUN chmod a+x /home/$USER/sourceryg++-2020.08-3-nios2-linux-gnu/sourceryg++-2020.08-3-nios2-linux-gnu.sh

## ".bin file"
#ARG TOOLCHAIN="sourceryg++-2018.05-5-nios2-linux-gnu.bin"
#RUN cd /home/$USER && wget https://sourcery.mentor.com/GNUToolchain/package15406/public/nios2-linux-gnu/${TOOLCHAIN}
#RUN chown $USER:$USER -R /home/$USER/${TOOLCHAIN}
#RUN chmod a+x /home/$USER/${TOOLCHAIN}

## "advanced TAR" (binary tarball)
#RUN cd /home/$USER/ && wget https://sourcery.mentor.com/GNUToolchain/package15404/public/nios2-linux-gnu/sourceryg++-2018.05-5-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
#RUN cd /home/$USER && tar xjf sourceryg++-2018.05-5-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
#RUN cp -arf /home/$USER/sourceryg++-2018.05/* /usr/local/
#RUN chown $USER:$USER -R /usr/local
#RUN rm -f /home/$USER/sourceryg++-2018.05-5-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
#RUN rm -rf /home/$USER/sourceryg++-2018.05

## NOTE: buildroot (2020.x) downloads specific code sourcery toolchain
## NOTE: buildroot (2020.x) downloads specific u-boot
## NOTE: buildroot (2020.x) downloads specific kernel


################################################################################
## set up tools

USER ${USER}
WORKDIR /home/${USER}

RUN mkdir -p /home/$USER/configs

## bash config
RUN rm -f /home/${USER}/.bashrc && ln -s /home/$USER/configs/.bashrc /home/$USER/

## vim config
RUN rm -f /home/${USER}/.vimrc && ln -s /home/$USER/configs/.vimrc /home/$USER/

## emacs config
RUN rm -f /home/${USER}/.emacs && ln -s /home/$USER/configs/.emacs /home/$USER/

## ssh
RUN mkdir -p /home/${USER}/.ssh


USER root

## codespell: dictionary fix
RUN mkdir -p /usr/share/codespell
RUN ln -s /usr/lib/python3/dist-packages/codespell_lib/data/dictionary.txt /usr/share/codespell/dictionary.txt


################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
