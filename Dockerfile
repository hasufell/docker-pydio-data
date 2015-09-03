FROM        hasufell/gentoo-amd64-paludis:20150820
MAINTAINER  Julian Ospald <hasufell@gentoo.org>

# install alien
RUN chgrp paludisbuild /dev/tty && cave resolve -z app-arch/rpm app-arch/cpio -x

# fetch pydio release
RUN wget http://dl.ajaxplorer.info/repos/el6/pydio-stable/pydio-6.0.8-1.noarch.rpm

# install pydio
RUN rpm2cpio pydio-6.0.8-1.noarch.rpm | cpio -idmv && \
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

