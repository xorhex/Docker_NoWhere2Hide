FROM golang:1.22.2 AS build

RUN apt update && apt upgrade -y && apt install git

RUN groupadd -g 1010 appgroup
RUN adduser appuser
RUN usermod -aG appgroup appuser
USER appuser
WORKDIR /app


#RUN git clone https://github.com/c2links/NoWhere2Hide.git
RUN git clone https://github.com/xorhex/NoWhere2Hide.git
WORKDIR /app/NoWhere2Hide/main

# Rebuild Go Modules as they need to be built with the same version of go as the program loading them
RUN ./rebuild_plugins.sh

# Build NoWhere2Hide
RUN go build -v -o NoWhere2Hide .
RUN chmod u+x ./docker_start.sh

ENTRYPOINT ./docker_start.sh
