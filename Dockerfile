FROM php:8.1-fpm

ENV TZ="Europe/Bucharest"
ENV COMPOSER_AUTH $COMPOSER_AUTH

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# update + install missing deps
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    curl \
    xz-utils \
    ssh \
    sudo \
    --no-install-recommends

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-enable pdo_mysql

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# making global tools
RUN mkdir -p /opt/tools/php
RUN chown -R $USERNAME /opt/tools

USER ${USERNAME}

# install PHP-CS, PHPStan [global]
RUN mkdir -p /opt/tools/php/php-cs-fixer
RUN composer require --dev --working-dir=/opt/tools/php/php-cs-fixer friendsofphp/php-cs-fixer

RUN mkdir -p /opt/tools/php/phpstan
RUN composer require --dev --working-dir=/opt/tools/php/phpstan phpstan/phpstan
RUN mkdir -p /opt/tools/php/phpunit
