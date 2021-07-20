# geoipupdate docker image

## How to use this image

Just run it with your configuration file and data volume/dir mapped

It runs with user/group id 10001

### Example

```sh
$ docker run --rm -v /etc/geoip.conf:/etc/GeoIP.conf -v geoip-data:/usr/share/GeoIP xbblabs/geoipupdate
```

### Crontab example

```
# At 12:00 on Wednesday
00 12 * * 3 docker run --rm -v /etc/geoip.conf:/etc/GeoIP.conf -v geoip-data:/usr/share/GeoIP xbblabs/geoipupdate
```
