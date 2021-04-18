#!/bin/bash
tool="/sbin/ethtool"
${tool} -C $1 adaptive-rx off adaptive-tx off
${tool} -G $1 tx 4096 rx 4096
${tool} -C $1 tx-frames-irq 2048
${tool} -C $1 rx-usecs 30
${tool} -A $1 tx off rx off

exit 0