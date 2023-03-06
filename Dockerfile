# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0


FROM ubuntu:20.04
ENV GOROOT=/usr/local/go
ENV PATH="$GOROOT/bin:$PATH"
ARG GO_VERSION=1.20.1
ARG GO_ARCHIVE="go${GO_VERSION}.linux-amd64.tar.gz"
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y wget unzip git cmake clang llvm python3-pip libncurses5
RUN wget "https://dl.google.com/go/${GO_ARCHIVE}" && tar -xvf $GO_ARCHIVE && \
   mkdir $GOROOT &&  mv go/* $GOROOT && rm $GO_ARCHIVE
RUN pip3 install wllvm

ADD ./SAW/scripts /lc/scripts
RUN /lc/scripts/docker_install.sh
ENV CRYPTOLPATH="../../../cryptol-specs:../../spec"

# This container expects all files in the directory to be mounted or copied. 
# The GitHub action will mount the workspace and set the working directory of the container.
# Another way to mount the files is: docker run -v `pwd`:`pwd` -w `pwd` <name>

ENTRYPOINT ["./SAW/scripts/docker_entrypoint.sh"]
