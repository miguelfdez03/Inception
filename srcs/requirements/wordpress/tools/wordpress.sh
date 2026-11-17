#!/bin/bash
set -e

mkdir -p /var/www/html/wordpress /run/php

cd /var/www/html/wordpress

if [ ! -f "wp-config.php" ]; then
    echo "Waiting for MariaDB service..."
    while ! mariadb-admin ping -h mariadb -u "${DB_USER}" -p"${DB_USER_PASS}" --silent >/dev/null 2>&1; do
        sleep 2
    done
    echo "MariaDB is ready. Installing WordPress..."

    wp core download --allow-root --path=/var/www/html/wordpress

    wp config create --allow-root \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_USER_PASS}" \
        --dbhost="mariadb:3306" \
        --path=/var/www/html/wordpress

    wp core install --allow-root \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception - Portfolio miguel-f" \
        --admin_user="${WP_ADMIN}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN}@student.42malaga.com" \
        --skip-email \
        --path=/var/www/html/wordpress

    wp user create "${WP_USER}" "${WP_USER}@student.42malaga.com" \
        --role=author \
        --user_pass="${WP_USER_PASS}" \
        --allow-root \
        --path=/var/www/html/wordpress

    # Install clean modern theme
    wp theme install twentytwentyfour --activate --allow-root --path=/var/www/html/wordpress

    # Remove default placeholder posts/pages
    wp post delete 1 --force --allow-root --path=/var/www/html/wordpress 2>/dev/null || true
    wp post delete 2 --force --allow-root --path=/var/www/html/wordpress 2>/dev/null || true
    wp post delete 3 --force --allow-root --path=/var/www/html/wordpress 2>/dev/null || true

    # Create an initial post with comments open for the evaluation requirements
    wp post create --post_type=post \
        --post_title="Welcome to Inception by miguel-f" \
        --post_content="This WordPress site is running on dedicated Docker containers deployed for the Inception project at 42 Malaga. Feel free to leave a comment below to test persistence." \
        --post_status=publish \
        --comment_status=open \
        --allow-root \
        --path=/var/www/html/wordpress

    # Ensure comments are enabled globally for evaluator testing
    wp option update default_comment_status open --allow-root --path=/var/www/html/wordpress

    chown -R www-data:www-data /var/www/html/wordpress
    chmod -R 755 /var/www/html/wordpress
fi

sed -i 's#listen = /run/php/.*#listen = 0.0.0.0:9000#g' /etc/php/8.2/fpm/pool.d/www.conf

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
