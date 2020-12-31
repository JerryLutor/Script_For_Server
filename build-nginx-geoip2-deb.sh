#!/bin/bash

nginxver=`apt show nginx-full |grep Version | awk '{print $2}' |awk -F '-' '{print $1}'`

nginxname=nginx-$nginxver.tar.gz
nginxdir=nginx-$nginxver

#apt -y install libmaxminddb0 libmaxminddb-dev mmdb-bin

if [ -f "$nginxname" ]
then
    echo "$nginxname found. Remove"
    rm $nginxname
    rm -rf $nginxdir/
fi
#wget http://nginx.org/download/$nginxname
#tar -zxvf nginx-$nginxver.tar.gz
apt-src install nginx-full
cd $nginxdir

#./configure --add-dynamic-module=../ --without-http_rewrite_module --without-http_gzip_module
./configure --with-cc-opt='-g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security -fPIC -Wdate-time -D_FORTIFY_SOURCE=2' \
--with-ld-opt='-Wl,-Bsymbolic-functions -fPIE -pie -Wl,-z,relro -Wl,-z,now -fPIC' --prefix=/usr/share/nginx \
--conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log \
--lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid --modules-path=/usr/lib/nginx/modules \
--http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module \
--with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module --with-http_v2_module \
--with-http_dav_module --with-http_slice_module --with-threads --with-http_addition_module --with-http_flv_module \
--with-http_geoip_module=dynamic --with-http_gunzip_module --with-http_gzip_static_module \
--with-http_image_filter_module=dynamic --with-http_mp4_module --with-http_perl_module=dynamic \
--with-http_random_index_module --with-http_secure_link_module --with-http_sub_module --with-http_xslt_module=dynamic \
--with-mail=dynamic --with-mail_ssl_module --with-stream=dynamic --with-stream_ssl_module --with-stream_ssl_preread_module \
--add-dynamic-module=../
make

cp objs/ngx_http_geoip2_module.so ../