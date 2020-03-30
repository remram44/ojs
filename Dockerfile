FROM php:7.4.4-apache

# Install APT dependencies
RUN apt-get update && \
    apt-get install -yy git unzip npm && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -Lo /tmp/composer-installer https://getcomposer.org/installer && \
    php /tmp/composer-installer --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer && \
    rm /tmp/composer-installer

# PHP extensions
RUN docker-php-ext-configure gettext && docker-php-ext-install gettext

# Run composer
COPY lib/pkp lib/pkp
COPY plugins/paymethod/paypal plugins/paymethod/paypal
COPY plugins/generic/citationStyleLanguage plugins/generic/citationStyleLanguage
# XXX curl hack to inject GitHub token
RUN curl -Lo /root/.composer/auth.json http://172.17.0.1:8000/auth.json && \
    composer --working-dir=lib/pkp update && \
    composer --working-dir=plugins/paymethod/paypal update && \
    composer --working-dir=plugins/generic/citationStyleLanguage update && \
    rm /root/.composer/auth.json

# Run NPM
RUN npm install && \
    npm build

# Copy the rest of the files
COPY . ./
