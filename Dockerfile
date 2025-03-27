FROM php:8.1-cli

# Set working directory
WORKDIR /app

# Copy project files
COPY . /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    unzip zip curl mariadb-client \
    && docker-php-ext-install pdo pdo_mysql \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist

# Keep the container running for debugging
ENTRYPOINT ["tail", "-f", "/dev/null"]
