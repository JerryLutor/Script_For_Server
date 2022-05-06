#!/bin/sh

sleep 4
echo "========================FFMPEG ENEL Videos=========================="
while :; do
  ffmpeg -hide_banner -nostdin -loglevel error \
  -hwaccel_device 0 -hwaccel cuvid -hwaccel_output_format cuda \
  -i ${URL} \
  -filter_complex \
  "split=3[v1][v2][v3]; \
  [v1]scale_npp=w=1920:h=1080:interp_algo=lanczos,setdar=16:9,setsar=1:1[v1out]; \
  [v2]scale_npp=w=720:h=576:interp_algo=lanczos,setdar=16:9,setsar=1:1[v2out]; \
  [v3]scale_npp=w=320:h=240:interp_algo=lanczos,setdar=16:9,setsar=1:1[v3out]" \
  -map [v1out] -c:v:0 h264_nvenc -gpu 0 -x264-params "nal-hrd=cbr:force-cfr=1" -r 25 -b:v:0 7M -maxrate:v:0 10M -minrate:v:0 5M -bufsize:v:0 3M -preset fast -g 48 -keyint_min 48 \
  -map [v2out] -c:v:1 h264_nvenc -gpu 0 -x264-params "nal-hrd=cbr:force-cfr=1" -r 25 -b:v:1 2M -maxrate:v:1 3M  -minrate:v:1 1M -bufsize:v:1 1M -preset fast -g 48 -keyint_min 48 \
  -map [v3out] -c:v:2 h264_nvenc -gpu 0 -x264-params "nal-hrd=cbr:force-cfr=1" -r 25 -b:v:1 1M -maxrate:v:1 2M  -minrate:v:1 1M -bufsize:v:1 1M -preset 4 -g 48 -keyint_min 48 \
  -map a:0 -c:a:0 aac -b:a:0 128k -ac:a:0 2 \
  -map a:0 -c:a:1 aac -b:a:1 48k  -ac:a:1 2 \
  -map a:0 -c:a:2 aac -b:a:2 48k  -ac:a:2 2 \
  -f hls \
  -hls_time 5 \
  -hls_flags independent_segments \
  -hls_list_size 120 \
  -hls_segment_type mpegts \
  -hls_flags delete_segments+discont_start+split_by_time \
  -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:576p v:2,a:2,name:240p" \
  -master_pl_publish_rate 10 \
  -master_pl_name video.m3u8 \
  -hls_segment_filename /var/www/"${NAMECH}"/%v/content%01d.ts /var/www/"${NAMECH}"/%v/mono.m3u8
  wait
done
echo "========================END FFMPEG ENEL Videos======================"