FROM php:8.1-apache

# Copia o código da aplicação para o diretório padrão do Apache
COPY . /var/www/html/

# Ajusta permissões para o Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

EXPOSE 80
