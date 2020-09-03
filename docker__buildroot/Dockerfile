FROM i386/debian:10
MAINTAINER Lothar Rubusch <l.rubusch@gmail.com>
WORKDIR /root
ENV DEBIAN_FRONTEND=noninteractive


################################################################################
## the USER is needed to make it available as --build-arg
## in case docker complains for a not set USER, perhaps you forgot to use --build-arg USER=$USER
ARG USER=""

## gmail user
ARG GMAIL_USER=""

## email address at gmail
ARG GMAIL=""

## email password for that address
ARG GMAIL_PASSW=""


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
    wget

## for building documentation targets
RUN apt-get install -y  \
    kmod \
    cpio \
    imagemagick \
    graphviz \
    dvipng \
    fonts-noto-cjk \
    latexmk \
    librsvg2-bin \
    virtualenv \
    python3-sphinx \
    python3-sphinx-rtd-theme

## for building development environment
RUN apt-get install -y  \
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
    bc

## my add ons for patch development
RUN apt-get install -y  \
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
RUN sudo su $USER -c "mkdir -p /home/$USER/linux"
RUN sudo su $USER -c "mkdir -p /home/$USER/configs"

## reset permissions
RUN chown $USER:$USER -R /home/$USER/linux
RUN chown $USER:$USER -R /home/$USER/configs

RUN cd /home/$USER && git clone -j4 --depth=1 --branch lothar/2020.05.x-nios2 https://github.com/Rubusch/buildroot.git buildroot

## alternatively get official buildrooot
#RUN git clone -j4 --depth=1 https://github.com/buildroot/buildroot.git buildroot
RUN chown $USER:$USER -R /home/$USER/buildroot

## toolchain
## source package (installer is not supposed to work, read preamble), most releases don't publish a .bin file!!!
#RUN cd /home/$USER && wget https://sourcery.mentor.com/GNUToolchain/package15987/public/nios2-linux-gnu/sourceryg++-2020.08-3-nios2-linux-gnu.src.tar.bz2
#RUN cd /home/$USER && tar xjf sourceryg++-2020.08-3-nios2-linux-gnu.src.tar.bz2
#RUN chmod a+x /home/$USER/sourceryg++-2020.08-3-nios2-linux-gnu/sourceryg++-2020.08-3-nios2-linux-gnu.sh

## .bin file
#ARG TOOLCHAIN="sourceryg++-2018.05-5-nios2-linux-gnu.bin"
#RUN cd /home/$USER && wget https://sourcery.mentor.com/GNUToolchain/package15406/public/nios2-linux-gnu/${TOOLCHAIN}
#RUN chown $USER:$USER -R /home/$USER/${TOOLCHAIN}
#RUN chmod a+x /home/$USER/${TOOLCHAIN}

## "advanced" (but binary tarball)
RUN cd /home/$USER && wget https://sourcery.mentor.com/GNUToolchain/package15404/public/nios2-linux-gnu/sourceryg++-2018.05-5-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
RUN cd /home/$USER && tar xjf sourceryg++-2018.05-5-nios2-linux-gnu-i686-pc-linux-gnu.tar.bz2
RUN cp -arf /home/$USER/sourceryg++-2018.05/* /usr/local/
RUN chown $USER:$USER -R /usr/local

## u-boot
#RUN cd /home/$USER && git clone -j4 https://github.com/altera-opensource/u-boot-socfpga.git u-boot
RUN cd /home/$USER && git clone -j4 --branch lothar/develop https://github.com/Rubusch/u-boot.git u-boot
RUN chown $USER:$USER -R /home/$USER/u-boot

## kernel
#RUN cd /home/$USER && git clone https://github.com/altera-opensource/linux-socfpga.git linux
RUN cd /home/$USER && git clone --branch lothar/develop https://github.com/Rubusch/linux.git linux
RUN chown $USER:$USER -R /home/$USER/linux


################################################################################
## set up tools

## bash config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.bashrc" && sudo su $USER -c "ln -s /home/$USER/configs/.bashrc /home/$USER/"

## vim config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.vimrc" && sudo su $USER -c "ln -s /home/$USER/configs/.vimrc /home/$USER/"

## emacs config
RUN cd /home/$USER && sudo su $USER -c "rm -f /home/$USER/.emacs" && sudo su $USER -c "ln -s /home/$USER/configs/.emacs /home/$USER/"

## git config
RUN cd /home/$USER && sudo su $USER -c "git config --global user.name \"$GMAIL_USER\""
RUN cd /home/$USER && sudo su $USER -c "git config --global user.email $GMAIL"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.st status"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.ci commit"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.co checkout"
RUN cd /home/$USER && sudo su $USER -c "git config --global alias.br branch"

RUN cd /home/$USER && sudo su $USER -c "git config --global sendemail.from \"$GMAIL_USER <$GMAIL>\""
RUN cd /home/$USER && sudo su $USER -c "git config --global sendemail.smtpserver smtp.gmail.com"
RUN cd /home/$USER && sudo su $USER -c "git config --global sendemail.smtpuser $GMAIL"
RUN cd /home/$USER && sudo su $USER -c "git config --global sendemail.smtpencryption tls"
RUN cd /home/$USER && sudo su $USER -c "git config --global sendemail.smtppass $GMAIL_PASSW"
RUN cd /home/$USER && sudo su $USER -c "git config --global sendemail.chainreplyto false"
RUN cd /home/$USER && sudo su $USER -c "git config --global sendemail.smtpserverport 587"

## codespell: dictionary fix
RUN mkdir -p /usr/share/codespell
RUN ln -s /usr/lib/python3/dist-packages/codespell_lib/data/dictionary.txt /usr/share/codespell/dictionary.txt


################################################################################
## command mode
COPY build.sh /usr/local/bin/build.sh
CMD ["/bin/bash", "/usr/local/bin/build.sh"]
