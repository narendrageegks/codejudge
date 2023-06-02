FROM php:7.4-apache
ARG WORDPRESS_VERSION=5.8
ARG WORDPRESS_URL=https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz

WORKDIR /var/www/html
RUN apt-get update && apt-get install -y \
    wget \
    tar \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd mysqli zip

RUN wget -O wordpress.tar.gz ${WORDPRESS_URL} && \
    tar -xzf wordpress.tar.gz --strip-components=1 && \
    rm wordpress.tar.gz

COPY .htaccess /var/www/html/.htaccess
COPY wordpress.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite && \
    chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["apache2-foreground"]
