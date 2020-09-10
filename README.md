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

### U-Boot - DTS

Generate the ``sopc2dts.jar`` file  

```
$ git clone https://github.com/wgoossens/sopc2dts.git
$ cd sopc2dts
$ make
```

Copy .jar file   

```
$ cd ..
$ cp ./sopc2dts/sopc2dts.jar .
```

Generate .dts file  

```
$ java -jar ./sopc2dts.jar --force-altr -i ./linux_hw.sopcinfo -o linux_hw.dts
```


## Deployment

### Login

u: root  
p: N/A  


### Flash the NIOS 2 System to the target

Flash logic design from quartus to the board, connect via USB blaster II. Generate the .cdf file. Easiest is via graphical Programmer in Quartus, once the *C*hain *D*escription *F*ile was saved, then _quartus_pgm_ can use it from off the shell.  

```
$ cd <path to quartus project>
$ $ quartus_pgm -c 1 ./output_files/linux_hw.cdf
```

alternatively via .sof (*S*RAM *O*bject *F*ile)   

```
$ quartus_pgm --debug  -m jtag -c 1 -o "p;./output_files/linux_hw.sof@2"
```

Where ``-o <options>;<input_file>@<device_index`` is to be applied, i.e. FPGA is of index 2 on my DE1 SoC board, so I take ``@2``.  


### Build U-Boot

Best is to set up a docker container with the corresponding toolchain (Mentor Graphics Code Sourcery).   

Note: there are several releases, which only contain the SOURCE packages. As can be read in the .sh file (Linux) this is not for installation, but only for "understanding how Mentor Graphics builds toolchains". Some other Editions, also contain binary packages, which then can be installed on 32bit Linux or Linux with compatibility 32bit libc package installed. In general a better approach is to get buildroot, and build the BSP or SDK from there. Buildroot fetches and sets up the latest Code Sourcery Toolchain.   

Then go into the sources, e.g. cloned u-boot sources, adjust  
* ``./configs/my_nios2_defconfig`` (template e.g. ``10m50_devconfig``)  
* ``./include/configs/my_nios2.h`` (template e.g. ``10m50_devboard.h``)  
* ``./arch/nios2/dts/my_nios2.dts`` (generated from ``sopc2dts.jar`` as above, template ``10m50_devboard.dts``)  


### Flash U-Boot to the target

Now via the ``nios2-download`` and ``nios2-flash-programmer`` tools try to flash the images to the board.  

references:  

* https://rocketboards.org/foswiki/Documentation/NiosIILinuxUserManualForCycloneIII
* https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/niosii_generic_booting_methods.pdf

Using the Compact Flash Interface (CFI) TODO  

```
TODO
$ nios2-download -g -r u-boot.srec

$ nios2-terminal
TODO
```


### Tricks

NB: Sometimes it helps to turn the board off and on again before flashing.   

