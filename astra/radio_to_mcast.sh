#!/bin/sh
ps auxw | grep echo.msk.ru | grep -v grep  > /dev/null
if [ $? != 0 ]
then
ffmpeg -i http://ice912.echo.msk.ru:9120/24.aac  -acodec mp2  -f mpegts udp://229.0.0.1:4013/?pkt_size=1316 &   > /dev/null
fi
#