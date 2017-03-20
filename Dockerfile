FROM ubuntu
MAINTAINER betaflight

# If you want to tinker with this Dockerfile on your machine do as follows:
# - git clone https://github.com/betaflight/docker-betaflight-build.git
# - vim docker-betaflight-build/Dockerfile
# - docker build -t betaflight-build docker-betaflight-build
# - cd <your betaflight source dir>
# - docker run --rm -ti -v `pwd`:/opt/betaflight betaflight-build

ENV ARM_SDK_NAME="gcc-arm-none-eabi-6-2017-q1-update"

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common git make ccache python curl bzip2
RUN curl -L https://developer.arm.com/-/media/Files/downloads/gnu-rm/6_1-2017q1/${ARM_SDK_NAME}-linux.tar.bz2 -o /tmp/${ARM_SDK_NAME}-linux.tar.bz2
RUN mkdir -p /opt
RUN cd /opt; tar xjf /tmp/${ARM_SDK_NAME}-linux.tar.bz2

RUN mkdir -p /opt/betaflight
WORKDIR /opt/betaflight

# Config options you may pass via Docker like so 'docker run -e "<option>=<value>"':
# - PLATFORM=<name>, specify target platform to build for
#   Specify 'ALL' to build for all supported platforms. (default: NAZE)
#
# What the commands do:
ENV ARM_SDK_DIR="/opt/${ARM_SDK_NAME}/bin/"

CMD GCC_VERSION=$(${ARM_SDK_DIR}arm-none-eabi-gcc -dumpversion) && \
    if [ -z ${PLATFORM} ]; then \
        PLATFORM="NAZE"; \
    fi && \
    if [ ${PLATFORM} = ALL ]; then \
        PATH=${PATH}:${ARM_SDK_DIR} make GCC_REQUIRED_VERSION=${GCC_VERSION} clean_all && \
        PATH=${PATH}:${ARM_SDK_DIR} make GCC_REQUIRED_VERSION=${GCC_VERSION} all; \
    else \
        PATH=${PATH}:${ARM_SDK_DIR} make GCC_REQUIRED_VERSION=${GCC_VERSION} clean TARGET=${PLATFORM} && \
        PATH=${PATH}:${ARM_SDK_DIR} make GCC_REQUIRED_VERSION=${GCC_VERSION} TARGET=${PLATFORM}; \
    fi
