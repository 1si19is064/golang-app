# Build stage
FROM golang:1.24 AS builder

WORKDIR /app
COPY go.mod ./
RUN go mod download

COPY . .

RUN go build -o app

# Final minimal image
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/app .

EXPOSE 8080

CMD ["./app"]
