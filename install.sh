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
SERVER="$(curl -s https://update.pmmp.io/api)"
CHANNEL=$(jq -r ".channel" < $SERVER)
CHANNEL_QUOTE=$(jq ".channel" < $SERVER)
echo -e "[*] Retrieving latest build data for channel ${CHANNEL_QUOTE}"
PMMP_VER=$(jq -r ".base_version" < $SERVER)
MCPE_VER=$(jq -r ".mcpe_version" < $SERVER)
PHP_PMMP=$(jq -r ".php_version" < $SERVER)
BUILD=$(jq -r ".build" < $SERVER)
DATE=$(jq -r ".date" < $SERVER)
DATE_CONVERT=$(date --date="@${DATE}")
echo -e "[*] This stable build was released on $DATE_CONVERT"
echo -e "[*] Found PocketMine-MP ${PMMP_VER} (build ${BUILD}) for Minecraft: PE v${MCPE_VER} (PHP ${PHP_PMMP})"
echo "[*] Installing/updating PocketMine-MP on directory ./"
mkdir -p ./bin/php7/bin/
## Install php binary for ARM Device
wget -q $(curl -s https://api.github.com/repos/DaisukeDaisuke/AndroidPHP/releases | jq -r .[0].assets[1].browser_download_url)
mv php ./bin/php7/bin
wget -q $(curl -s https://api.github.com/repos/DaisukeDaisuke/AndroidPHP/releases | jq -r .[0].assets[0].browser_download_url)
mv php.ini ./bin/php7/bin/
chmod +x ./bin/php7/bin/php
# Install PMMP
wget -q -O PocketMine-MP.phar https://github.com/pmmp/PocketMine-MP/releases/download/${PMMP_VER}/PocketMine-MP.phar
wget -q -O start.sh https://raw.githubusercontent.com/pmmp/PocketMine-MP/${PMMP_VER}/start.sh
chmod +x start.sh

echo -e "[*] Everything done! Run ./start.sh to start PocketMine-MP"
exit 0
