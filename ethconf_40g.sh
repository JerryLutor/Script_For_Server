#!/bin/bash

tool="/sbin/ethtool"

${tool} -G $1 tx 3096 rx 3096
${tool} -C $1 tx-frames-irq 2048
#${tool} -C $1 rx-usecs 30
${tool} -A $1 tx off rx off
exit 0
