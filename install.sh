#!/data/data/com.termux/files/usr/bin/bash
PMMP_VER="4.10.11"
PHP_VER="8.0.22"
if ! command -v curl &> /dev/null; then
  echo "[*] Command curl not found"
  exit 1
fi
if ! command -v getconf &> /dev/null; then
  echo "[*] Command getconf not found"
  exit 1
fi

if [ `getconf LONG_BIT` == "32" ]; then
	echo "[*] PocketMine-MP is no longer supported on 32-bit systems."
	exit 1
fi
if [[ "$TERMUX_VERSION" < "0.118.0" ]]; then
  echo -e "Please use the lastest version of Termux\nFor more Information: https://github.com/termux/termux-app#Installation"
  exit 1
fi
echo "[*] Installing/updating PocketMine-MP on directory ./"
mkdir -p ./bin/php7/bin/
echo "[*] Installing PHP 8.0.22 Binary"
curl -s -o php https://github.com/DaisukeDaisuke/AndroidPHP/releases/download/{PHP_VER}/php
mv php ./bin/php7/bin
curl -s -o php.ini https://github.com/DaisukeDaisuke/AndroidPHP/releases/download/{PHP_VER}/php-pm4.ini
mv php.ini ./bin/php7/bin/
chmod +x ./bin/php7/bin/php
echo -e "[*] Installing PocketMine-MP {PMMP_VER}"
curl -s -o PocketMine-MP.phar https://github.com/pmmp/PocketMine-MP/releases/download/{PMMP_VER}/PocketMine-MP.phar/
curl -s -o start.sh https://github.com/pmmp/PocketMine-MP/releases/download/{PMMP_VER}/start.sh/
chmod +x start.sh
echo -e "[*] Everything done! Run ./start.sh to start PocketMine-MP"
exit 0
