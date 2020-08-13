##
## author: Piotr Stawarski <piotr.stawarski@zerodowntime.pl>
##

ARG BASE_IMAGE=centos:7

FROM $BASE_IMAGE

# python3 for deps
RUN yum -y install \
      python3 \
      python3-pip \
    && yum clean all \
    && rm -rf /var/cache/yum /var/tmp/* /tmp/*


# jq comes to help for parsing JSON files
RUN curl -s -L https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
      -o /usr/local/bin/jq && \
    chmod 755 /usr/local/bin/jq


# kubectl comes to help when running inside k8s
RUN VER=$(curl -L https://dl.k8s.io/release/stable.txt) && \
    curl -L https://dl.k8s.io/release/$VER/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl && \
    chmod 755 /usr/local/bin/kubectl


# azcopy for Azure storage accounts
RUN TMP=$(mktemp -d) && \
    curl -L https://aka.ms/downloadazcopy-v10-linux | tar xvz -C $TMP --strip-components 1 && \
    cp $TMP/azcopy /usr/local/bin/azcopy && \
    chmod 755 /usr/local/bin/azcopy && \
    rm -rf $TMP


# awscli for AWS s3 transfer
#RUN pip3 install awscli

# Copy wrappers/helpers scripts
COPY *.sh /opt/
