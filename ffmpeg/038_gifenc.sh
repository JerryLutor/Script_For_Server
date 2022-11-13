#!/bin/sh

# http://blog.pkh.me/p/21-high-quality-gif-with-ffmpeg.htmlS

# создаем GIF с правильной палитрой

palette="/tmp/palette.png"

filters="fps=15,scale=320:-1:flags=lanczos"

ffmpeg -v warning -i $1 -vf "$filters,palettegen" -y $palette
ffmpeg -v warning -i $1 -i $palette -lavfi "$filters [x]; [x][1:v] paletteuse" -y $2


# ...which can be used like this:
# % ./gifenc.sh video.mkv anim.gif




