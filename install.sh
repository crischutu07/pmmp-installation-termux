#!/data/data/com.termux/files/usr/bin/bash
## Checking commands if it exists

dependencies=( jq getconf curl wget )
for i in "${dependencies[@]}"; do
  package_manager='apt install -y'
  [[ $(command -v "$i") == "" ]] && $package_manager "$i" &> /dev/null
done
unset -v package_manager

if [ `getconf LONG_BIT` == "32" ]; then
        echo -e "[*] PocketMine-MP is no longer supported on 32-bit systems."
        read -p "[*] Do you want to continue this installation? [Y/N] " confirm
        case $confirm in
        [Yy]* ) :;;
        [Nn]* ) exit 1;;
        * ) exit 1;;
    esac
fi
# Check user if Termux Version is not 0.118.0
if [[ "$TERMUX_VERSION" < "0.118.0" ]]; then
  echo -e "Please use the lastest version of Termux\nFor more Information: https://github.com/termux/termux-app#Installation"
  exit 1
fi
# Export variable after checking command
CHANNEL=$(curl -s https://update.pmmp.io/api | jq -r ".channel")
CHANNEL_QUOTE=$(curl -s https://update.pmmp.io/api | jq ".channel")
PHP_VER="8.0.22" 
echo -e "[*] Retrieving latest build data for channel ${CHANNEL_QUOTE}"
PMMP_VER=$(curl -s https://update.pmmp.io/api | jq -r ".base_version")
MCPE_VER=$(curl -s https://update.pmmp.io/api | jq -r ".mcpe_version")
PHP_PMMP=$(curl -s https://update.pmmp.io/api | jq -r ".php_version")
BUILD=$(curl -s https://update.pmmp.io/api | jq -r ".build")
DATE=$(curl -s https://update.pmmp.io/api | jq -r ".date")
DATE_CONVERT=$(date --date="@${DATE}")
echo -e "[*] This stable build was released on $DATE_CONVERT"

echo -e "[*] Found PocketMine-MP ${PMMP_VER} (build ${BUILD}) for Minecraft: PE v${MCPE_VER} (PHP ${PHP_PMMP})"
echo "[*] Installing/updating PocketMine-MP on directory ./"
mkdir -p ./bin/php7/bin/
## Install php binary for ARM Device
wget -q -O php https://github.com/DaisukeDaisuke/AndroidPHP/releases/download/${PHP_VER}/php
mv php ./bin/php7/bin
wget -q -O php.ini https://github.com/DaisukeDaisuke/AndroidPHP/releases/download/${PHP_VER}/php-pm4.ini
mv php.ini ./bin/php7/bin/
chmod +x ./bin/php7/bin/php
# Install PMMP
wget -q -O PocketMine-MP.phar https://github.com/pmmp/PocketMine-MP/releases/download/${PMMP_VER}/PocketMine-MP.phar
wget -q -O start.sh https://raw.githubusercontent.com/pmmp/PocketMine-MP/${PMMP_VER}/start.sh
chmod +x start.sh

echo -e "[*] Everything done! Run ./start.sh to start PocketMine-MP"
exit 0
