FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    php8.2-fpm \
    php8.2-mysql \
    php8.2-curl \
    php8.2-gd \
    php8.2-mbstring \
    php8.2-xml \
    mariadb-client \
    curl \
    ca-certificates && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp && \
    rm -rf /var/lib/apt/lists/*

COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress.sh"]
