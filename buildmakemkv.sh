#!/bin/bash

set -x

PATH="$HOME/bin:$PATH"

apt-get update && apt-get -y upgrade
apt-get -y install checkinstall build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev libz-dev wget less tar grep sudo sed #vim

# Fix for bug 'checkinstall fails to create directories: https://bugs.launchpad.net/ubuntu/+source/checkinstall/+bug/815506'
sed -i -e 's/TRANSLATE=1/TRANSLATE=0/g' /etc/checkinstallrc

mkdir ~/makemkv_sources
cd ~/makemkv_sources

wget "http://www.makemkv.com/download/"
export curr_version=$(grep -m 1 "MakeMKV v" index.html | sed -e "s/.*MakeMKV v//;s/ (.*//")

echo "Scraped the MakeMKV download page and found the latest version as" ${curr_version}

export bin_zip=makemkv-bin-${curr_version}.tar.gz
export oss_zip=makemkv-oss-${curr_version}.tar.gz
export oss_folder=makemkv-oss-${curr_version}
export bin_folder=makemkv-bin-${curr_version}

wget http://www.makemkv.com/download/$bin_zip
wget http://www.makemkv.com/download/$oss_zip

tar -xzvf $bin_zip
tar -xzvf $oss_zip

cd $oss_folder
./configure
make
checkinstall make install

cd ../$bin_folder
#to disable "type 'yes' if you agree to license" (otherwise the docker build will fail):
sed -i -e 's/exit [[:digit:]]/exit 0/g' src/ask_eula.sh

make
checkinstall make install

cd ..
#remove downloaded files
rm index.html
rm $bin_zip
rm $oss_zip
#rm -rf $oss_folder
#rm -rf $bin_folder

set +x
clear
echo "You might want to do this now;"
echo "#1. on the host, execute:"
echo -e "\e[34mmkdir -p ~/tmp && docker run -t -i -v ~/tmp:/data docker-makemkv bash\e[0m"
echo "#2. in the docker container, execute: "
echo -e "\e[34mcp ~/makemkv_sources/makemkv-oss-*/makemkv-oss_*.deb /data/\e[0m"
echo -e "\e[34mcp ~/makemkv_sources/makemkv-bin-*/makemkv-bin_*.deb /data/\e[0m"
echo -e "\e[34mexit\e[0m"
echo "#3. on the host, you can now install makemkv by running:"
echo -e "\e[34mdpkg -i ~/tmp/makemkv-oss_*.deb && dpkg -i ~/tmp/makemkv-bin_*.deb\e[0m"
echo "#4. you can now remove ~/tmp/makemkv-oss_*.deb and ~/tmp/makemkv-bin_*.deb"
