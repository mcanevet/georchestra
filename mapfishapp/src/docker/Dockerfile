FROM georchestra/base

ADD . /

# Add gdal support
RUN apt-get update && \
   apt-get install -y libgdal1h libgdal-java gdal-bin zip && \
   rm -rf /var/lib/apt/lists/*

RUN mkdir -p /WEB-INF/lib/ && \
    cp /usr/share/java/gdal.jar /WEB-INF/lib/ && \
    zip -g /var/lib/jetty/webapps/mapfishapp.war /WEB-INF/lib/gdal.jar && \
    rm -fr /WEB-INF
