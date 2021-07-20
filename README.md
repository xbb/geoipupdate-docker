# geoipupdate docker image

## How to use this image

Just run it with your configuration file and data volume/dir mapped

It runs with user/group id 10001

You can print the bundled example configuration file by specifying `config` as the first argument

### Example: prints the bundled example configuration file

```sh
$ docker run --rm -v xbblabs/geoipupdate config
```

### Example: runs geoipupdate with the provided configuration file and destination volume

```sh
$ docker run --rm -v /etc/geoip.conf:/etc/GeoIP.conf -v geoip-data:/usr/share/GeoIP xbblabs/geoipupdate
```

### Crontab example

```
# At 12:00 on Wednesday
00 12 * * 3 docker run --rm -v /etc/geoip.conf:/etc/GeoIP.conf -v geoip-data:/usr/share/GeoIP xbblabs/geoipupdate
```
