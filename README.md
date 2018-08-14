# Docker Betaflight build
[![Docker Pulls](https://img.shields.io/docker/pulls/betaflight/betaflight-build.svg)](https://hub.docker.com/r/betaflight/betaflight-build/) [![Docker Stars](https://img.shields.io/docker/stars/betaflight/betaflight-build.svg)](https://hub.docker.com/r/betaflight/betaflight-build/) [![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg?style=flat)](https://github.com/betaflight/betaflight-build/blob/master/LICENSE)

Clone and edit [Betaflight](https://github.com/betaflight/betaflight) locally on your platform. This image will take it from there and turn your code into a binary which you then can flash to your flight controller with the [Betaflight Configurator](https://chrome.google.com/webstore/detail/betaflight-configurator/kdaghagfopacdngbohiknlhcocjccjao).

## Usage
### Install Docker
The latest docker platform is available from [https://www.docker.com/](https://www.docker.com/products/overview#/install_the_platform). If your system does not meet the system requirements for the latest version, check out the [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

### Clone the Betaflight repository
Docker runs on a VirtualBox VM which by default only shares the user directory from the underlying guest OS. On Windows that is `c:/Users/<user>` and on Mac it's `/Users/<user>`. Hence, you need to clone the  [Betaflight](https://github.com/betaflight/betaflight) repository to your *user directory*. If you want to place it outside the user directory you need to adjust the [VirtualBox VM sharing settings](http://stackoverflow.com/q/33934776/131929) accordingly.

### Run this image with Docker
Start Docker and change into the Betaflight source directory (in the Docker console).

First you need to set your working directory in Docker:

For Windows -
`cd /c/users/<user name>`

Next, Clone the Betaflight repository.
(Note the below link is for the main Betaflight project.  If Cloning a workign Fork, you  will need to get the link from the GitHub website.)

To Clone a Github repository
`git clone https://github.com/betaflight/betaflight.git`

To view Branches within a repository
`git branch -a`

To checkout a branch
`git checkout <branch name>`

To pull the branch to your local PC
`git pull`

Then run:
``docker run --rm -ti -v `pwd`:/opt/betaflight betaflight/betaflight-build``

Depending on the performance of your system it takes 1-3min until the compilation finishes. The first time you run this it takes longer because Docker needs to download the image and create a container.

**Note for Windows users**

(Docker on) Windows handles paths slightly differently. You need to specify the full path to the Betaflight directory in the command and you need to add an extra forward slash (`/`) to the Windows path. The command thus becomes (`c` equals C drive i.e. `c:`):

`docker run --rm -it -v //c/Users/<user>/<betaflight>:/opt/betaflight betaflight/betaflight-build`

If the Windows path contains spaces it would have to be wrapped in quotes as usual on Windows.

`docker run --rm -it -v "//c/Users/joe blogs/<betaflight>":/opt/betaflight betaflight/betaflight-build`

#### Output
The firmware file (`.bin` or `.hex`) is created in the `obj` subfolder of your betaflight source directory.

#### Options
You can pass optional parameters to the Docker build like so:

``docker run -e "<parameter>=value" --rm -it -v `pwd`:/opt/betaflight betaflight/betaflight-build`` 

For Windows:
``docker run -e "PLATFORM=<target name>" --rm -it -v //c/Users/<user>/<any sub-directory names>/betaflight:/opt/betaflight betaflight/betaflight-build`` 

These parameters are supported:

- `PLATFORM=<target name>` The platform (target) to build. Use `ALL` to build for all platforms. (default: `NAZE`)
                           e.g.: `PLATFORM=SPRACINGF3` 
- `OPTIONS=<options>` specify build options to be used as defines during the build

### Flashing the built binary
Use the [Betaflight Configurator](https://chrome.google.com/webstore/detail/betaflight-configurator/kdaghagfopacdngbohiknlhcocjccjao) Chrome app to flash and configure your firmware.

## Support
Don't leave comments on Docker Hub that are intended to be support requests, since Docker Hub doesn't send notifications when you write them. Instead create an issue on [GitHub](https://github.com/betaflight/docker-betaflight-build/issues).
