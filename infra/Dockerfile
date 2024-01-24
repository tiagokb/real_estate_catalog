# caminho: infra/Dockerfile

# Etapa 1 - Define a imagem base
# Estamos utilizando a imagem oficial do PHP com o servidor de processamento PHP-FPM na versão 8.1.2
FROM php:8.1.2-fpm

# Define o diretório de trabalho dentro do container
# Este diretório será a referência para os comandos que serão executados dentro do container
WORKDIR /var/www

# Etapa 2 - Adiciona o instalador de extensões do PHP e instala as extensões necessárias
# O script de instalação de extensões facilita a instalação de extensões do PHP dentro do container
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions intl mbstring sockets bcmath pdo_mysql zip exif pcntl gd memcached && \
    apt-get update && \
    apt-get install -y build-essential nginx supervisor wget git openssl libssl-dev procps htop libicu-dev && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 && \
    chmod +x /usr/local/bin/dumb-init && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Etapa 3 - Baixa e instala o composer
# O composer é o gerenciador de dependências do PHP
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Etapa 4 - Copia o código da aplicação e configura a aplicação
# Aqui estamos copiando os arquivos do host para o container, copiando arquivos de configuração para seus respectivos destinos e ajustando as permissões de diretórios e arquivos
COPY . /var/www
COPY .env.example ./.env
COPY infra/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY infra/nginx/nginx.conf /etc/nginx/nginx.conf
COPY infra/nginx/vhost.conf /etc/nginx/sites-enabled/default
COPY infra/php-fpm/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY infra/start.sh /start.sh
RUN chmod +x /start.sh

# Expõe as portas 80 e 443 para permitir o tráfego de entrada no container
EXPOSE 80 443

# Define o comando que será executado quando o container iniciar
# Neste caso, estamos iniciando o supervisor, que irá gerenciar os processos do nginx e do php-fpm
CMD ["/start.sh"]
