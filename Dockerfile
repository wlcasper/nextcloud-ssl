FROM nextcloud:22.2.6-apache
MAINTAINER Liang Wang

RUN apt-get update && apt-get install -y fonts-wqy-* fonts-liberation2 fonts-arphic-gbsn00lp fonts-arphic-gkai00mp fonts-arphic-ukai fonts-arphic-uming fonts-noto-cjk fonts-noto-cjk-extra fonts-open-sans ssl-cert

RUN a2enmod ssl && a2ensite default-ssl

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
