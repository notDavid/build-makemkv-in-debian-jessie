# build makemkv 
#
# VERSION 0.0.1

FROM debian:latest
MAINTAINER David <https://github.com/notDavid>

#makemkv build info: http://www.makemkv.com/forum2/viewtopic.php?f=3&t=224

ENV HOME /root

ADD         buildmakemkv.sh /tmp/
RUN         chmod +x /tmp/buildmakemkv.sh
RUN         /tmp/buildmakemkv.sh | tee /root/buildlog.docker.makemkv
