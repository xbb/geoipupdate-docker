#!/usr/bin/env sh

if [ "$1" = "config" ]; then
    exec cat /etc/GeoIP.conf
fi

exec /usr/bin/geoipupdate "$@"

