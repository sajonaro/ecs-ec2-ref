# Build Stage 1
# Compile Composer dependencies
FROM composer:1.9 AS composer
WORKDIR /var/www
COPY ./source-code/. /var/www
#RUN composer install --ignore-platform-reqs --no-interaction --no-dev --prefer-dist --optimize-autoloader

# Build Stage 2
# Compile NPM assets
FROM node:12.13.0-alpine AS build-npm
WORKDIR /var/www
COPY --from=composer /var/www /var/www
RUN npm install --silent --no-progress
#RUN npm run prod --silent --no-progress
RUN rm -rf node_modules


# Runtime stage
FROM php:7.3-fpm-alpine

# Setup document root
WORKDIR /var/www/html
   
# Install NGINX
RUN apk add --no-cache \
    curl \
    nginx \
    supervisor 
    
# Configure nginx - http
COPY config/nginx.conf /etc/nginx/nginx.conf

# Configure nginx - default server
COPY config/conf.d /etc/nginx/conf.d/
    
# Configure PHP-FPM 
#(PHP_INI_DIR is defined in the base image, pointsto /usr/local/etc/php)
COPY config/fpm-pool.conf ${PHP_INI_DIR}/php-fpm.d/www.conf
COPY config/php.ini ${PHP_INI_DIR}/conf.d/custom.ini
    
# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
    
# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN chown -R nobody.nobody /var/www/html /run /var/lib/nginx /var/log/nginx
    
# Switch to use a non-root user from here on
USER nobody

# Copy source code and NPM files from previous stage
COPY --from=build-npm /var/www /var/www/html
    
# Expose the port nginx is reachable on
EXPOSE 8080
    
# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
    
# Configure a healthcheck to validate that everything is up&running
#HEALTHCHECK --timeout=15s CMD curl --silent --fail http://127.0.0.1:8080 || exit 1