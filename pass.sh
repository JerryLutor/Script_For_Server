#!/bin/sh
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin

openssl rand -base64 500 | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1
