#!/bin/bash

if [ -n "$1" ]
then
file=`echo "$1" | sed 's/\.mp4//g'`;
echo $file;
mkdir $file;
time ffmpeg -hide_banner -y -vsync 1 -async 1 -hwaccel cuda -hwaccel_output_format cuda -i $1  -g 25 \
-filter:v:0 scale_npp=-2:1080:interp_algo=super,hwdownload,format=nv12 -c:a aac -c:v h264_nvenc -preset p7 -b:v 5140k $file/$file'_hd'.mp4 \
-filter:v:0 scale_npp=-2:576:interp_algo=super,hwdownload,format=nv12 -c:a aac -c:v h264_nvenc -preset p4 -b:v 2960k $file/$file'_fhd'.mp4 \
-filter:v:0 scale_npp=-2:360:interp_algo=super,hwdownload,format=nv12 -c:a aac -c:v h264_nvenc -b:v 1160k $file/$file'_sd'.mp4

ffmpeg -i $file/$file'_hd'.mp4 -i $file/$file'_fhd'.mp4 -i $file/$file'_sd'.mp4 -map 0:v:0 -map 1:v:0 -map 2:v:0 -map 0:a? -c:v copy  -c:a copy $file/$file'_multivideo'.mp4

#апаратное транскодирование с сжатием до 5140k, удалением мета данных и перегоном звука 5.1 в stereo
#ffmpeg -hide_banner -y -vsync 1 -async 1 -hwaccel cuda -hwaccel_output_format cuda -i X02353.mkv -g 25 -filter:v:0 scale_npp=1920x800:interp_algo=super,hwdownload,format=nv12 -map_chapters -1 -c:a aac -ac 2 -af "pan=stereo|FL=FC+0.30*FL+0.30*BL|FR=FC+0.30*FR+0.30*BR" -c:v h264_nvenc -preset medium -b:v 5140k  -map_metadata -1 X02353.mp4
#

else
echo "no parametrs";
exit
fi
