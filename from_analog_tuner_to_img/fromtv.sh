#!/bin/bash

i=1
tdir=$(/bin/date +%s)
mkdir /var/www/mosaic/$tdir
chmod 777 /var/www/mosaic/$tdir

export tdir
export i

/usr/bin/v4l2-ctl --set-freq=49.25
sleep 1
for A in 49 59 77 85 93 111 119 127 135 143 151 159 167 175 183 191 199 207 215 223 231 239 247 255 263 271 279 287 295 303 311 319 327 335 343 351 359 367 375 383 391 399 407 415 423 431 439 447 455 463 471 479 487 495 503 511 519 527 535 543 551 559 567 575 583 591 599 607 615 623 631 639 647 655 663 671 679 687 695 703
do

    sleep 1
    /usr/bin/v4l2-ctl --set-freq=$A.25
    sleep 1
    /usr/local/bin/ffmpeg -f video4linux2 -i /dev/video0 -vframes 1 -s 640x480 /var/www/mosaic/$tdir/$i.jpg
    i=$[$i+1]
done
sleep 1

echo "mkdir"
/bin/mkdir /mnt/mosaic/
echo "mount"
/bin/mount -t cifs -o username=xxxxxxxy,password=123456789,vers=1.0 //x.x.x.x/smbuser /mnt/mosaic/
echo "mkdir"
/bin/mkdir /mnt/mosaic/jg/
echo "copy"
/bin/cp /var/www/mosaic/$tdir/* /mnt/mosaic/jg/

find /var/www/mosaic/* -type f -mmin +360 -delete | xargs rm -rf
find /var/www/mosaic/* -type d -mmin +360 -delete | xargs rm -rf


exit 0
