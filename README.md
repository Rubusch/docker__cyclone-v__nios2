# Build Container for my linux on NIOS2 (softcore on Altera/Intel's DE1-SoC Board)

Contains a Dockerfile for building an docker image and its container for the Software and BSP using buildroot.


## Build

The setup needs a gmail email address for patch delivery via ``git send-email``, provide a valid gmail address if intended to work on patches  

**NOTE** Replace ``gmail user name``, ``email@gmail.com`` and ``gmail password`` with your gmail credentials  

**NOTE** For the gamil passwords containing ``<`` and ``>`` i.e. use escaped ``\\\<`` and ``\\\>``, in any case don't use quotes.  

```
$ cd ./docker__buildroot

$ time docker build --no-cache --build-arg USER=$USER --build-arg GMAIL_USER="<gmail user name>" --build-arg GMAIL=<email@gmail.com> --build-arg GMAIL_PASSW=<gmail password> -t rubuschl/nios2-buildroot:$(date +%Y%m%d%H%M%S) .
    10m...
```

Use ```--no-cache``` when re-implementing the docker image.


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

