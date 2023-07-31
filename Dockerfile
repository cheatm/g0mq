FROM golang:1.20

WORKDIR /go/src/app

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y vim
RUN apt-get install -y libzmq3-dev
RUN apt-get install -y libczmq-dev

RUN go env -w GOPROXY="https://goproxy.io"
ADD ./go.mod .
ADD ./go.sum . 
RUN go mod download -x

COPY . .
RUN go build -o main ./main.go

FROM ubuntu

RUN apt update
RUN apt-get install -y libzmq3-dev
RUN apt-get install -y libczmq-dev
# RUN apt install -y ca-certificates
COPY --from=0 /go/src/app/main .

CMD ./main