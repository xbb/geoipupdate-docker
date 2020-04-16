# Build
FROM golang:alpine as build

ARG VERSION=v4.3.0

RUN apk add --update --no-cache git
RUN git clone --branch ${VERSION} https://github.com/maxmind/geoipupdate.git /build

WORKDIR /build/cmd/geoipupdate
RUN GOOS=linux go build -ldflags="-w -s" -o /geoipupdate

# Release
FROM alpine:latest

ENV USER=johndoe
ENV UID=10001
# See https://stackoverflow.com/a/55757473/12429735
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    "${USER}"

COPY --from=build /geoipupdate /usr/bin/geoipupdate

USER johndoe:johndoe

ENTRYPOINT ["/usr/bin/geoipupdate"]

CMD ["-v", "-f", "/etc/GeoIP2.conf", "-d", "/usr/share/GeoIP"]
