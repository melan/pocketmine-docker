FROM ubuntu:latest

MAINTAINER melanchenko@gmail.com

RUN apt-get update \
  && apt-get install -y language-pack-en-base software-properties-common dpkg-dev \
                        devscripts libxml2 libxml2-dev make autoconf automake libtool \
                        m4 wget libc-bin gzip bzip2 bison g++ git libtool-bin libyaml-dev \
                        \
  && mkdir -p /opt/pocketmine \
  && cd /opt/pocketmine \
  && git clone https://github.com/PocketMine/php-build-scripts.git \
  && cd php-build-scripts \
  && perl -i -pe 's/((?:\w+)VERSION(?:\w*))="(.+)"/$1=\${$1:-$2}/' ./compile.sh \
  && PHP_VERSION=7.0.8 CURL_VERSION=curl-7_49_1 PHPYAML_VERSION=2.0.0RC8 LIBPNG_VERSION=1.6.23 ./compile.sh -t linux64 -f x86_64 \
  && cd /opt/pocketmine \
  && git clone --recursive https://github.com/PocketMine/PocketMine-MP.git

WORKDIR /opt/pocketmine/PocketMine-MP

RUN useradd -d /opt/pocketmine/PocketMine-MP -M -U -r pocketmine \
  && find . -depth -name ".git*" -exec rm -rf {} \; \
  && touch banned-players.txt && chown pocketmine:pocketmine banned-players.txt \
  && touch banned-ips.txt && chown pocketmine:pocketmine banned-ips.txt \
  && touch ops.txt && chown pocketmine:pocketmine ops.txt \
  && touch server.log && chown pocketmine:pocketmine server.log \
  && touch white-list.txt && chown pocketmine:pocketmine white-list.txt \
  && mkdir players && chown -R pocketmine:pocketmine players \
  && mkdir worlds && chown -R pocketmine:pocketmine worlds \
  && apt-get purge -y python* perl libpython* git m4 wget make autoconf automake dpkg-dev gcc \
  && apt autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY pocketmine.yml /opt/pocketmine/PocketMine-MP/
COPY server.properties /opt/pocketmine/PocketMine-MP/

EXPOSE 19132/udp

CMD ./start.sh -p /opt/pocketmine/php-build-scripts/bin/php7/bin/php

