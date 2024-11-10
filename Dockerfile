FROM php:8.1-apache

# Instala as dependências necessárias e a extensão mysqli
RUN apt-get update && apt-get install -y \
    libmariadb-dev-compat \
    libmariadb-dev \
    default-mysql-client \
    && docker-php-ext-install mysqli \
    && docker-php-ext-enable mysqli

# Copia o código da aplicação para o diretório padrão do Apache
COPY . /var/www/html/

# Ajusta permissões para o Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expõe a porta 80 para o Apache
EXPOSE 80

