FROM alpine:3.18 AS build

ARG PACKER_VERSION
ARG PACKER_VERSION_SHA256SUM

COPY packer_${PACKER_VERSION}_linux_amd64.zip .
RUN echo "${PACKER_VERSION_SHA256SUM}  packer_${PACKER_VERSION}_linux_amd64.zip" > checksum && sha256sum -c checksum

RUN /usr/bin/unzip packer_${PACKER_VERSION}_linux_amd64.zip


FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim
RUN apt-get -y update && apt-get -y install ca-certificates
RUN apt-get install python3 python3-pip -y && rm -rf /var/lib/apt/lists/*
RUN pip3 install ansible ansible-core==2.13.9
RUN pip3 install jmespath
#RUN pip3 install pipx
#RUN pipx install ansible-core
#RUN pipx inject ansible-core jmespath
COPY --from=build packer /usr/bin/packer
ENTRYPOINT ["/usr/bin/packer"]
