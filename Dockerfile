FROM        busybox:latest
MAINTAINER  Julian Ospald <hasufell@gentoo.org>

ENV PYDIO_VERSION 6.0.8

RUN mkdir -p /var/www
RUN wget -O /tmp/pydio-core-${PYDIO_VERSION}.zip http://downloads.sourceforge.net/project/ajaxplorer/pydio/stable-channel/${PYDIO_VERSION}/pydio-core-${PYDIO_VERSION}.zip
RUN unzip /tmp/pydio-core-${PYDIO_VERSION}.zip -d /var/www
RUN mv /var/www/pydio-core-* /var/www/pydio

# create common group to be able to synchronize permissions to shared data volumes
RUN addgroup -g 777 www

# fix pydio group permissions so php and nginx both can have access
RUN chown -R :www /var/www/pydio && chmod -R g+w /var/www/pydio

# cleanup
RUN rm /tmp/pydio-core-${PYDIO_VERSION}.zip

VOLUME ["/var/www/pydio"]

