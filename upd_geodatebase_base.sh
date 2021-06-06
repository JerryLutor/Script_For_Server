#! /bin/sh

curl -s https://api.github.com/repos/P3TERX/GeoLite.mmdb/releases/latest \
| grep "browser_download_url.*GeoLite2-Country.mmdb" \
| cut -d '"' -f 4 \
| wget -qi - -O /opt/flussonic/lib/egeoip2/priv/GeoLite2-Country.mmdb
