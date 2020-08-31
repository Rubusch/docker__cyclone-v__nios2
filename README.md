# Build Container for my linux on NIOS2 (softcore on Altera/Intel's DE1-SoC Board)

Contains a Dockerfile for building an docker image and its container for the Software and BSP using buildroot.

## Build


```
$ cd ./docker__buildroot/
$ time docker build --build-arg USER=$USER -t rubuschl/nios2-buildroot:$(date +%Y%m%d%H%M%S) .
```
Use ```--no-cache``` when re-implementing the docker image.


## Usage

```
$ docker images
    REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/nios2-buildroot 20191104161353      cbf4cb380168        24 minutes ago      10.5GB
    ubuntu                      xenial              5f2bf26e3524        4 days ago          123MB

$ time docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/dl:/home/$USER/buildroot/dl -v $PWD/output:/home/$USER/buildroot/output rubuschl/nios2-buildroot:20191104161353
```

## Debug

```
$ docker images
    REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
    rubuschl/nios2-buildroot 20191104161353      cbf4cb380168        24 minutes ago      10.5GB
    ubuntu                      xenial              5f2bf26e3524        4 days ago          123MB

$ docker run --rm -ti --user=$USER:$USER --workdir=/home/$USER -v $PWD/dl:/home/$USER/buildroot/dl -v $PWD/output:/home/$USER/buildroot/output rubuschl/nios2-buildroot:20191104161353 /bin/bash
```


## Image

### Login

u: root  
p: N/A  

