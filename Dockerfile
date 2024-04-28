FROM golang:1.22.2 AS build

#RUN apk update && apk upgrade && apk add git
RUN apt update && apt upgrade && apt install git

#RUN addgroup -S appgroup && adduser -S appuser -G appgroup -h /app
RUN groupadd -g 1010 appgroup
RUN adduser appuser
RUN usermod -aG appgroup appuser
USER appuser
WORKDIR /app


#RUN git clone https://github.com/c2links/NoWhere2Hide.git
RUN git clone https://github.com/xorhex/NoWhere2Hide.git
WORKDIR /app/NoWhere2Hide/main

# Rebuild Go Modules as they need to be built with the same version of go as the program loading them
RUN go build -buildmode=plugin -o ./plugin/targets/badasn/badasn.so ./plugin/targets/badasn/badasn.go 
RUN go build -buildmode=plugin -o ./plugin/targets/censys/censys.so ./plugin/targets/censys/censys.go 
RUN go build -buildmode=plugin -o ./plugin/targets/shodan/shodan.so ./plugin/targets/shodan/shodan.go 
RUN go build -buildmode=plugin -o ./plugin/targets/ipsum/ipsum.so ./plugin/targets/ipsum/ipsum.go
RUN go build -buildmode=plugin -o ./plugin/c2/Trochilus/trochilus_banner.so ./plugin/c2/Trochilus/trochilus_banner.go 

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
