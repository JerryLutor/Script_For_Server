#! /bin/sh
wget -q -O /etc/apt/trusted.gpg.d/flussonic.gpg http://apt.flussonic.com/binary/gpg.key;
echo "deb http://apt.flussonic.com binary/" > /etc/apt/sources.list.d/flussonic.list;
apt update;
