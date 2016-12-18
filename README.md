# build-makemkv-in-debian-jessie
Build, create .deb &amp; install makemkv in debian jessie - optionally using docker

```
git clone https://github.com/notDavid/build-makemkv-in-debian-jessie.git
cd build-makemkv-in-debian-jessie
docker build -t="docker-makemkv" .
# on the host:
mkdir -p ~/tmp && docker run -t -i -v ~/tmp:/data docker-makemkv bash
# in the container:
cp ~/makemkv_sources/makemkv-oss-*/makemkv-oss_*.deb /data/
cp ~/makemkv_sources/makemkv-bin-*/makemkv-bin_*.deb /data/
exit
# on the host, to install makemkv:
dpkg -i ~/tmp/makemkv-oss_*.deb && dpkg -i ~/tmp/makemkv-bin_*.deb
```
