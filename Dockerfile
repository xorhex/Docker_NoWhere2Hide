FROM golang:1.22.2 AS build

RUN apt update && apt upgrade -y && apt install git

RUN groupadd -g 1010 appgroup
RUN adduser appuser
RUN usermod -aG appgroup appuser
USER appuser
WORKDIR /app


RUN git clone https://github.com/c2links/NoWhere2Hide.git
WORKDIR /app/NoWhere2Hide/main

# Rebuild Go Modules as they need to be built with the same version of go as the program loading them
RUN ./rebuild_plugins.sh

# Build NoWhere2Hide
RUN go build -v -o NoWhere2Hide .

WORKDIR /app/NoWhere2Hide

# Update api keys
RUN sed -i -r 's/censys_api_id: ""/censys_api_id: \"${CENSYS_API_ID}\"/g' api.yaml
RUN sed -i -r 's/censys_secret: ""/censys_secret: \"${CENSYS_SECRET}\"/g' api.yaml
RUN sed -i -r 's/shodan: ""/shodan: \"${SHODQN}\"/g' api.yaml
RUN sed -i -r 's/huntio: ""/huntio: \"${HUNTIO}\"/g' api.yaml

WORKDIR /app/NoWhere2Hide/main

ENTRYPOINT ./NoWhere2Hide
