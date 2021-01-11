FROM ubuntu:20.04

LABEL maintainer="ronnie.gilad@gmail.com"

# For root priviledges
ENV USER root

# Preliminary installations for server
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip3 install --upgrade pip

# Copy as a new layer
COPY . /kandula

WORKDIR /kandula

# Setting environment for Kandula app
RUN pip3 install -r ./requirements.txt
RUN chmod +x ./bin/run

# Run Kandula app
ENTRYPOINT ["/bin/bash", "./bin/run"]
