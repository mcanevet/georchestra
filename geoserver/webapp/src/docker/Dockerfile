FROM georchestra/base

RUN echo "deb http://httpredir.debian.org/debian jessie contrib" >> /etc/apt/sources.list
RUN echo "deb http://security.debian.org/ jessie/updates contrib" >> /etc/apt/sources.list

RUN apt-get update && \
   apt-get install -y ttf-mscorefonts-installer  && \
   rm -rf /var/lib/apt/lists/*

ADD . /
ADD https://github.com/georchestra/geoserver_minimal_datadir/archive/master.zip /tmp/datadir.zip

RUN chmod +x /start.sh

CMD /start.sh

