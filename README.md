# Build Container for my linux on NIOS2 (softcore on Altera/Intel's DE1-SoC Board)

Nios II is a 32-bit embedded-processor architecture designed specifically for the Altera family of FPGAs. A Dockerfile for building a docker image for the Software and BSP using buildroot.  

The image uses the code sourcery toolchain (build up by buildroot or in comments downloaded from mentor graphics directly), the toolchain is 32bit thus needs libc6 32bit support.  

![The minimal Nios2 logic design on a DE1 SoC Board](pics/qsys.png)

## Build

```
$ cd ./docker__buildroot

$ time docker build --build-arg USER=$USER -t rubuschl/nios2-buildroot:$(date +%Y%m%d%H%M%S) .
    10m...
```

Use ```--no-cache``` to re-build the base docker image.


## Usage

```
$ docker images
    REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/nios2-buildroot 20191104161353      cbf4cb380168        24 minutes ago      10.5GB
    ubuntu                      xenial              5f2bf26e3524        4 days ago          123MB

$ time docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/dl:/home/$USER/buildroot/dl -v $PWD/output:/home/$USER/buildroot/output rubuschl/nios2-buildroot:20191104161353
```

## Debug

```
$ docker images
    REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/nios2-buildroot 20191104161353      cbf4cb380168        24 minutes ago      10.5GB
    ubuntu                      xenial              5f2bf26e3524        4 days ago          123MB

$ docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/configs:/home/$USER/configs -v $PWD/dl:/home/$USER/buildroot/dl -v $PWD/output:/home/$USER/buildroot/output rubuschl/nios2-buildroot:20191104161353 /bin/bash
```


## Image

### Login

u: root  
p: N/A  

