FROM nextcloud:25.0.10-apache
MAINTAINER Liang Wang

RUN apt-get update && apt-get install -y fonts-wqy-* fonts-liberation2 fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-arphic-ukai fonts-arphic-uming fonts-noto-cjk fonts-noto-cjk-extra fonts-open-sans wget gnupg2 unzip liblapack-dev libopenblas-dev libx11-dev libbz2-dev

# Enable repo and install dlib
RUN echo "deb https://repo.delellis.com.ar bullseye bullseye" > /etc/apt/sources.list.d/20-pdlib.list \
  && wget -qO - https://repo.delellis.com.ar/repo.gpg.key | apt-key add -
RUN apt update \
  && apt install -y libdlib-dev

# Install pdlib extension
RUN wget https://github.com/goodspb/pdlib/archive/master.zip \
  && mkdir -p /usr/src/php/ext/ \
  && unzip -d /usr/src/php/ext/ master.zip \
  && rm master.zip
RUN docker-php-ext-install pdlib-master
RUN docker-php-ext-install bz2

# Increase memory limits
RUN echo memory_limit=4096M > /usr/local/etc/php/conf.d/memory-limit.ini

# These last lines are just for testing the extension.. You can delete them.
RUN wget https://github.com/matiasdelellis/pdlib-min-test-suite/archive/master.zip \
  && unzip -d /tmp/ master.zip \
  && rm master.zip
RUN cd /tmp/pdlib-min-test-suite-master \
    && make

# apt-get install ssl-cert

# Use existing cert, instead of creating new one for new
# containers. Cert path is hard-coded in
# /etc/apache2/site-available/default-ssl.conf.

ADD ssl-cert-snakeoil.pem /etc/ssl/certs/
RUN chmod 644 /etc/ssl/certs/ssl-cert-snakeoil.pem

ADD ssl-cert-snakeoil.key /etc/ssl/private/
RUN chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key

RUN a2enmod ssl && a2ensite default-ssl

# ENV PHP_MEMORY_LIMIT 4G

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
