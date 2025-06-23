FROM php:8.3-fpm-bookworm

# Set timezone to Asia/Bangkok
ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create a single custom .ini file
RUN printf "\
session.gc_maxlifetime = 7200\n\
session.cookie_lifetime = 7200\n\
display_errors = Off\n\
error_reporting = E_ALL & ~E_DEPRECATED & ~E_NOTICE\n\
date.timezone = Asia/Bangkok\n\
" > /usr/local/etc/php/conf.d/99-custom.ini

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt update && apt install -y \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libldb-dev \
    libonig-dev \
    libxml2-dev \
    zlib1g-dev \
    git \
    unzip \
    libzip-dev \
    zip \
    vim \
    && docker-php-ext-install \
    intl \
    zip \
    pdo_mysql \
    mysqli \
    gd

# Install PHP extensions
RUN docker-php-ext-install \
    mysqli \
    pdo_mysql \
    mbstring \
    intl \
    pdo \
    exif \
    pcntl \
    bcmath \
    gd \
    zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Set working directory
WORKDIR /usr/share/nginx/html
