# Docker Betaflight build
[![Docker Pulls](https://img.shields.io/docker/pulls/betaflight/betaflight-build.svg)](https://hub.docker.com/r/betaflight/betaflight-build/) [![Docker Stars](https://img.shields.io/docker/stars/betaflight/betaflight-build.svg)](https://hub.docker.com/r/betaflight/betaflight-build/) [![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg?style=flat)](https://github.com/betaflight/betaflight-build/blob/master/LICENSE)

_(Markdown optimised for display in [Dockerhub](https://hub.docker.com/r/betaflight/betaflight-build).)_

Clone and edit [Betaflight](https://github.com/betaflight/betaflight) locally on your platform. This image will take it from there and turn your code into a binary which you then can flash to your flight controller with the [Betaflight Configurator](https://github.com/betaflight/betaflight-configurator).

## Usage
### Install Docker
The latest docker platform is available from [https://www.docker.com/](https://www.docker.com/products/overview#/install_the_platform). If your system does not meet the system requirements for the latest version, check out the [Docker Toolbox](https://www.docker.com/products/docker-toolbox).

### Clone the Betaflight repository
Docker runs on a VirtualBox VM which by default only shares the user directory from the underlying guest OS. On Windows that is <code>c:/Users/&lt;user&gt;</code> and on Mac it's <code>/Users/&lt;user&gt;</code>. Hence, you need to clone the  [Betaflight](https://github.com/betaflight/betaflight) repository to your *user directory*. If you want to place it outside the user directory you need to adjust the [VirtualBox VM sharing settings](http://stackoverflow.com/q/33934776/131929) accordingly.

### Run this image with Docker
Start Docker and change into the Betaflight source directory (in the Docker console).

First you need to set your working directory in Docker:

For Windows -
<code>cd /c/users/&lt;user name&gt;</code>

Next, Clone the Betaflight repository.
(Note the below link is for the main Betaflight project.  If Cloning a workign Fork, you  will need to get the link from the GitHub website.)

To Clone a Github repository
<code>git clone https://github.com/betaflight/betaflight.git</code>

To view Branches within a repository
<code>git branch -a</code>

To checkout a branch
<code>git checkout &lt;branch name&gt;</code>

To pull the branch to your local PC
<code>git pull</code>

Then run:
<code>docker run --rm -ti -v \`pwd\`:/opt/betaflight betaflight/betaflight-build</code>

Depending on the performance of your system it takes 1-3min until the compilation finishes. The first time you run this it takes longer because Docker needs to download the image and create a container.

**Note for Windows users**

(Docker on) Windows handles paths slightly differently. You need to specify the full path to the Betaflight directory in the command and you need to add an extra forward slash (<code>/</code>) to the Windows path. The command thus becomes (<code>c</code> equals C drive i.e. <code>c:</code>):

<code>docker run --rm -it -v c:/Users/&lt;user&gt;/&lt;betaflight&gt;:/opt/betaflight betaflight/betaflight-build</code>

If the Windows path contains spaces it would have to be wrapped in quotes as usual on Windows.

<code>docker run --rm -it -v "c:/Users/joe blogs/&lt;betaflight&gt;":/opt/betaflight betaflight/betaflight-build</code>

#### Output
The firmware file (<code>.bin</code> or <code>.hex</code>) is created in the <code>obj</code> subfolder of your betaflight source directory.

#### Options
You can pass optional parameters to the Docker build like so:

<code>docker run -e "&lt;parameter&gt;=value" --rm -it -v \`pwd\`:/opt/betaflight betaflight/betaflight-build</code> 

For Windows:
<code>docker run -e "parameter=&lt;value&gt;" --rm -it -v c:/Users/&lt;user&gt;/&lt;any sub-directory names&gt;/betaflight:/opt/betaflight betaflight/betaflight-build</code> 

These parameters are supported:

- <code>TARGET=&lt;target name&gt;</code>: The platform (target) to build, e.g. <code>TARGET=STM32F7X2</code>;
- <code>OPTIONS=&lt;options&gt;</code>: specify build options to be used as defines during the build.

Special cases:
- <code>TARGET=all</code>: build all targets (may take a long time);
- <code>TARGET=test</code>: build and run the unit tests;
- <code>TARGET=unified</code>: build all Unified Targets;
- <code>TARGET=unified\zip</code>: build all Unified Targets and pack them into ZIP files (good for adding to GitHub issues);
- <code>TARGET=pre-push</code>: build representative targets and build and run the tests (**do this to check that your changes do not introduce build failures every time before opening a pull request**).

### Flashing the built binary
Use the [Betaflight Configurator](https://chrome.google.com/webstore/detail/betaflight-configurator/kdaghagfopacdngbohiknlhcocjccjao) Chrome app to flash and configure your firmware.

## Support
Don't leave comments on Docker Hub that are intended to be support requests, since Docker Hub doesn't send notifications when you write them. Instead create an issue on [GitHub](https://github.com/betaflight/docker-betaflight-build/issues).
