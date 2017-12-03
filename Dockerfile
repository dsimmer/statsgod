FROM golang AS build-env

COPY . ./src/github.com/Dolmant/statsgod

RUN cd ./src/github.com/Dolmant/statsgod/ && go get
RUN CGO_ENABLED=0 go build -o ./src/github.com/Dolmant/statsgod/statsgodexec ./src/github.com/Dolmant/statsgod/statsgod.go 

FROM alpine
ADD ca-certificates.crt /etc/ssl/certs/
WORKDIR /
RUN mkdir /root/statsgod
COPY --from=build-env /go/src/github.com/Dolmant/statsgod/statsgodexec /root/statsgod
COPY --from=build-env /go/src/github.com/Dolmant/statsgod/config.yml /root/statsgod
ENTRYPOINT ["/root/statsgod/statsgodexec", "-config=/root/statsgod/config.yml"]

# Document that the service listens on port 8125 (TCP) and 8126 (UDP).
EXPOSE 8125
EXPOSE 8126

# Document that the service will be communicating with the backend on port 8086.
EXPOSE 8086
