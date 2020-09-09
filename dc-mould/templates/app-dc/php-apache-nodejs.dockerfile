FROM php:7.2.25-apache-buster

ARG UID
ARG GID

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN mkdir -p /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN apt-get update && apt-get install --no-install-recommends --yes git unzip libpng-dev libzip-dev

RUN git config --global url."https://".insteadOf git://

RUN docker-php-ext-install bcmath

RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-configure zip --with-libzip && docker-php-ext-install zip

RUN docker-php-ext-install exif

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN pecl install xdebug-2.6.0 && docker-php-ext-enable xdebug

RUN mkdir -p /usr/local/nvm

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 12.16.1

# Install nvm with node and npm
RUN curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/versions/node/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN npm install --global cross-env

RUN a2enmod rewrite

RUN mkdir -p /usr/src/aidock/build/log && touch /usr/src/aidock/build/log/php-error.log && chmod 777 /usr/src/aidock/build/log/php-error.log
RUN mkdir -p /usr/src/aidock/build/share

RUN if grep -q "^appuser" /etc/group; then echo "Group already exists."; else groupadd -g $GID appuser; fi
RUN useradd -m -r -u $UID -g appuser appuser

RUN apt-get update && apt-get install --no-install-recommends --yes libicu-dev
RUN docker-php-ext-configure intl && docker-php-ext-install intl

RUN apt-get update && apt-get install --no-install-recommends -y libfreetype6-dev libjpeg62-turbo-dev \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd