#!/bin/sh
PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
mkdir /usr/backup/
chmod 777 /usr/backup/
apt install lftp

FTPIP="127.0.0.1"
fl=`date "+%Y-%m-%d"`
cd /usr/backup/
#резервная копия файлов
FILES="/etc/ /home/ /var/www/ /var/spool/cron/ /root/ /usr/local/ebs/ /usr/lib/zabbix/ /usr/local/bin/ /usr/lib/zabbix/ /usr/share/GeoIP/"
NAME=`/bin/hostname`_`/bin/date '+%Y-%m-%d'`
/bin/tar -cPzf /usr/backup/${NAME}.tar.gz ${FILES}

#ротация файлов
find . -name \*.tar.gz -mtime +3 -delete
#
cd /usr/backup;
#отправляем бэкапы на FTP
/usr/bin/lftp -u login,pass ${FTPIP} -e "cd ftpbackup;mkdir `/bin/hostname`;cd `/bin/hostname`;mkdir ${fl};cd ${fl};mput ${NAME}.tar.gz;quit"
