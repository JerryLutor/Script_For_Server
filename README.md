# Script_For_Server
Script_For_Server

saa7134 0000:08:04.0: firmware: direct-loading firmware dvb-fe-tda10046.fw


cd ~/Downloads
wget https://github.com/JerryLutor/Script_For_Server/raw/master/linux-firmware-nonfree_1.16_all.deb
ar p linux-firmware-nonfree_1.16_all.deb data.tar.xz | unxz | tar x ./lib/firmware/dvb-fe-tda10046.fw --strip-components=3
