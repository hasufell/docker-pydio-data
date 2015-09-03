FROM        centos:centos6
MAINTAINER  Julian Ospald <hasufell@gentoo.org>

RUN yum install -y wget
RUN rpm -Uvh http://dl.ajaxplorer.info/repos/pydio-release-1-1.noarch.rpm
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN wget -q -O – http://www.atomicorp.com/installers/atomic | sh
RUN rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

# install pydio
RUN yum install -y --disablerepo=pydio-testing pydio-6.0.8 && \
	rm -rf /etc/httpd /var/log/pydio && \
	find /usr/share/pydio -name '.htaccess' -delete && \
	find /var/cache/pydio -name '.htaccess' -delete && \
	find /var/lib/pydio -name '.htaccess' -delete

# fix LANG
RUN echo "define(\"AJXP_LOCALE\", \"en_US.UTF-8\");" \
	>> /etc/pydio/bootstrap_conf.php

# fix for nginx, which doesn't work well with aliases
# see https://serverfault.com/questions/417357/nginx-appends-the-path-given-in-the-uri
RUN ln -s /var/lib/pydio/public/ /var/lib/pydio/public/pydio_public

# create common group to be able to synchronize permissions to shared data volumes
RUN groupadd -g 777 www

# fix permissions
RUN chown -R :www /var/lib/pydio /var/cache/pydio && \
	chmod -R g+w /var/lib/pydio /var/cache/pydio

