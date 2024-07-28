FROM php:8.2-fpm-bookworm

# set timezone
ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# update package
RUN apt update

# Install system dependencies
RUN apt -y install wget curl vim libpng-dev libzip-dev libicu-dev libldb-dev libonig-dev libxml2-dev zip zlib1g zlib1g-dev mariadb-client

# Clear cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install mysqli pdo_mysql mbstring intl pdo exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer/composer:latest-bin /composer /usr/bin/composer

# Set working directory
WORKDIR /usr/share/nginx/html