# Build
FROM golang:1.20-alpine as build

ARG VERSION=v5.1.1

RUN apk add --update --no-cache git
RUN git clone --branch ${VERSION} --depth 1 https://github.com/maxmind/geoipupdate.git /build

WORKDIR /build/cmd/geoipupdate
RUN GOOS=linux go build \
    -ldflags="-s -w -X main.version=${VERSION} -X main.defaultConfigFile=/etc/GeoIP.conf -X main.defaultDatabaseDirectory=/usr/share/GeoIP" \
    -o /geoipupdate

# Release
FROM alpine:3.19

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
COPY --from=build /build/conf/GeoIP.conf.default /etc/GeoIP.conf

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER geoip:geoip

ENTRYPOINT ["/entrypoint.sh"]

CMD ["-v", "-f", "/etc/GeoIP.conf", "-d", "/usr/share/GeoIP"]
