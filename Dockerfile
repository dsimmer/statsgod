FROM golang AS build-env

COPY . ./src/github.com/Dolmant/statsgod

RUN go get -u github.com/Dolmant/statsgod
RUN CGO_ENABLED=0 go build -o ./src/github.com/Dolmant/statsgod/statsgodexec ./src/github.com/Dolmant/statsgod/statsgod.go 

FROM alpine
ADD ca-certificates.crt /etc/ssl/certs/
WORKDIR /
RUN mkdir /root/statsgod
COPY --from=build-env /go/src/github.com/Dolmant/statsgod/statsgodexec /root/statsgod
COPY --from=build-env /go/src/github.com/Dolmant/statsgod/config.yaml /root/statsgod
ENTRYPOINT ["/root/statsgod/statsgodexec", "/root/statsgod/config.yaml"]

# Document that the service listens on port 8125 (TCP) and 8126 (UDP).
EXPOSE 8125
EXPOSE 8126
