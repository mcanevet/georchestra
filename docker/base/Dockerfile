FROM jetty:9.3-jre8

MAINTAINER PSC "psc@georchestra.org"

RUN apt-get update && \
    apt-get install -y unzip && \
		rm -rf /var/lib/apt/lists/*

RUN java -jar "$JETTY_HOME/start.jar" --add-to-startd=jmx,jmx-remote,stats

ADD https://github.com/georchestra/datadir/archive/docker-15.12.zip /tmp/georchestra.zip
RUN unzip /tmp/georchestra.zip -d /etc && mv /etc/datadir-docker-15.12 /etc/georchestra

CMD ["java","-Djava.io.tmpdir=/tmp/jetty", "-Dgeorchestra.datadir=/etc/georchestra","-jar","/usr/local/jetty/start.jar"]
