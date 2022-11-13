#!/bin/sh
OUTPUT=`iptables -nL | grep "INPUT" | sed  's/)//g' | sed  's/(//g' | awk '{print $4}'`;
#echo $OUTPUT;
if [ "$OUTPUT" = "ACCEPT" ]; then
    echo "1"
else
    echo "0"
fi
