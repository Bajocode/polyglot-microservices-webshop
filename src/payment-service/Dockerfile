FROM    golang:1.15
WORKDIR /go/src/app
COPY    ./src .
RUN     ["go","install"]
CMD     ["payment-service"]
