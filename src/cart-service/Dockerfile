FROM        golang:1.15-alpine AS builder
RUN         apk add git --no-cache
ENV         USER=docker UID=1234 GUID=4321
RUN         addgroup "${USER}" --gid "${GUID}" &&\
            adduser "${USER}" \
              --uid "${UID}" \
              --ingroup "${USER}" \
              --home /home/"${USER}" \
              --gecos "" \
              --disabled-password
USER        docker
WORKDIR     /home/docker
COPY        --chown=docker:docker src/go* ./
RUN         go mod download
COPY        --chown=docker:docker src .
RUN         CGO_ENABLED=0 go test ./... -v
RUN         go build -o ./dist .

FROM        alpine:3.13 AS target
RUN         apk add ca-certificates
ENV         USER=docker UID=1234 GUID=4321
RUN         addgroup "${USER}" --gid "${GUID}" &&\
            adduser "${USER}" \
              --uid "${UID}" \
              --ingroup "${USER}" \
              --home /home/"${USER}" \
              --gecos "" \
              --disabled-password
USER        docker
WORKDIR     /home/docker
COPY        --chown=docker:docker --from=builder /home/docker/dist ./app
EXPOSE      9002
ENTRYPOINT  ["./app"]
