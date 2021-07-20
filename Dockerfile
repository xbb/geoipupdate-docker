# Build
FROM golang:1.16-alpine as build

ARG VERSION=v4.7.1

RUN apk add --update --no-cache git
RUN git clone --branch ${VERSION} https://github.com/maxmind/geoipupdate.git /build

WORKDIR /build/cmd/geoipupdate
RUN GOOS=linux go build -ldflags="-w -s" -o /geoipupdate

# Release
FROM alpine:latest

ENV USER=geoip
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

USER geoip:geoip

ENTRYPOINT ["/usr/bin/geoipupdate"]

CMD ["-v", "-f", "/etc/GeoIP2.conf", "-d", "/usr/share/GeoIP"]
