FROM php:8.1-apache

# Copia o código da aplicação para o diretório padrão do Apache
COPY . /var/www/html/

# Ajusta permissões para o Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Instala extensões adicionais do PHP, se necessário (ex: MySQL)
RUN docker-php-ext-install mysqli pdo pdo_mysql

EXPOSE 80
