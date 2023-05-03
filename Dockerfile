# Compile stage
FROM golang:alpine AS build-env
ENV CGO_ENABLED 0
RUN apk --no-cache add build-base gcc git ca-certificates
ENV GOPROXY=direct
ADD . /sub_src
WORKDIR /sub_src
RUN go build -o /subscriber-svc

# Final stage
FROM alpine:latest
ENV TOPIC=/test/topic1
ENV QOS=0
ENV BROKER=192.168.1.30
ENV USEKAKFA=false
ENV KAFKAURL=localhost:9092,localhost:9093,localhost:9094
ENV KAFKATOPIC=/test/topic1
ENV PORT=1883
ENV USER=mqtt-user
ENV PASS=mqtt-pass
ENV CLIENTID=subscriber-x
ENV WRITESTDOUT=true
COPY --from=build-env /subscriber-svc /

# Run
CMD ["/subscriber-svc"]