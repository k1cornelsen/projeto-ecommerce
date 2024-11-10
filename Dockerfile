FROM php:8.1-apache

# Instala apenas as dependências essenciais para mysqli, sem bibliotecas adicionais com vulnerabilidades
RUN apt-get update && apt-get install -y \
    libmariadb-dev-compat \
    default-mysql-client \
    && docker-php-ext-install mysqli \
    && docker-php-ext-enable mysqli

# Remove bibliotecas que causam vulnerabilidades conhecidas
RUN apt-get remove -y \
    zlib1g-dev \
    libsqlite3-0 \
    libpam0g \
    libapr1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copia o código da aplicação para o diretório padrão do Apache
COPY . /var/www/html/

# Ajusta permissões para o Apache
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expõe a porta 80 para o Apache
EXPOSE 80

