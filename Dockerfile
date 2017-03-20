FROM ubuntu
MAINTAINER betaflight

# If you want to tinker with this Dockerfile on your machine do as follows:
# - git clone https://github.com/betaflight/docker-betaflight-build.git
# - vim docker-betaflight-build/Dockerfile
# - docker build -t betaflight-build docker-betaflight-build
# - cd <your betaflight source dir>
# - docker run --rm -ti -v `pwd`:/opt/betaflight betaflight-build

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y full-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common git make ccache python curl bzip2

ENV ARM_SDK_NAME="gcc-arm-none-eabi-6-2017-q1-update"
ENV ARM_SDK_FILE="${ARM_SDK_NAME}-linux.tar.bz2"
ENV ARM_SDK_URL="https://developer.arm.com/-/media/Files/downloads/gnu-rm/6_1-2017q1/${ARM_SDK_FILE}"

RUN curl -L ${ARM_SDK_URL} -o /tmp/${ARM_SDK_FILE}
RUN mkdir -p /opt
RUN cd /opt; tar xjf /tmp/${ARM_SDK_FILE}

RUN mkdir -p /opt/betaflight
WORKDIR /opt/betaflight

ENV ARM_SDK_DIR="/opt/${ARM_SDK_NAME}"

# Config options you may pass via Docker like so 'docker run -e "<option>=<value>"':
# - PLATFORM=<name>, specify target platform to build for
#   Specify 'ALL' to build for all supported platforms. (default: NAZE)
#
# What the commands do:

CMD if [ -z ${PLATFORM} ]; then \
        PLATFORM="NAZE"; \
    fi && \
    if [ ${PLATFORM} = ALL ]; then \
        make ARM_SDK_DIR=${ARM_SDK_DIR} clean_all && \
        make ARM_SDK_DIR=${ARM_SDK_DIR} all; \
    else \
        make ARM_SDK_DIR=${ARM_SDK_DIR} clean TARGET=${PLATFORM} && \
        make ARM_SDK_DIR=${ARM_SDK_DIR} TARGET=${PLATFORM}; \
    fi
