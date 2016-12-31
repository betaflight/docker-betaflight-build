FROM ubuntu
MAINTAINER betaflight

# If you want to tinker with this Dockerfile on your machine do as follows:
# - git clone https://github.com/betaflight/docker-betaflight-build.git
# - vim docker-betaflight-build/Dockerfile
# - docker build -t betaflight-build docker-betaflight-build
# - cd <your betaflight source dir>
# - docker run --rm -ti -v `pwd`:/opt/betaflight betaflight-build

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN DEBIAN_FRONTEND=noninteractive add-apt-repository -y ppa:team-gcc-arm-embedded/ppa
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install git make gcc-arm-none-eabi ccache python
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade

RUN mkdir /opt/betaflight
WORKDIR /opt/betaflight

# Config options you may pass via Docker like so 'docker run -e "<option>=<value>"':
# - PLATFORM=<name>, specify target platform to build for
#   Specify 'ALL' to build for all supported platforms. (default: NAZE)
#
# What the commands do:
CMD GCC_REQUIRED_VERSION=$(arm-none-eabi-gcc -dumpversion) && \
    if [ -z ${PLATFORM} ]; then \
      PLATFORM="NAZE"; \
    fi && \
    if [ ${PLATFORM} = ALL ]; then \
        make GCC_REQUIRED_VERSION=${GCC_REQUIRED_VERSION} clean_all && \
        make GCC_REQUIRED_VERSION=${GCC_REQUIRED_VERSION} all; \
    else \
        make GCC_REQUIRED_VERSION=${GCC_REQUIRED_VERSION} clean TARGET=${PLATFORM} && \
        make GCC_REQUIRED_VERSION=${GCC_REQUIRED_VERSION} TARGET=${PLATFORM}; \
    fi

