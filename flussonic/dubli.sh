#! /bin/sh
ps ax | grep coder | sed -r 's!^[^c]+!!' | sort -k1 |  uniq -d
