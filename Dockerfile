FROM nextcloud:20.0.6-apache
MAINTAINER Liang Wang

RUN apt-get update && apt-get install -y ssl-cert

RUN a2enmod ssl && a2ensite default-ssl

EXPOSE 80 443

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
