FROM ubuntu:latest
MAINTAINER Ian Foster <ian@vorsk.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y nginx php5-fpm php5-gd curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www
RUN cd /var/www && curl http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz | tar xz --strip 1
RUN chown -R www-data:www-data /var/www

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*
ADD dokuwiki.conf /etc/nginx/sites-enabled/

EXPOSE 80
VOLUME [ \
    "/var/www/data/", \
    "/var/www/conf/", \
    "/var/www/lib/tpl", \
    "/var/www/lib/plugins" \
]

CMD /usr/sbin/php5-fpm && /usr/sbin/nginx
