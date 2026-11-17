#!/bin/bash
set -e

mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

cat << EOF > /tmp/init.sql
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASS}' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
FLUSH PRIVILEGES;
EOF

chown mysql:mysql /tmp/init.sql

exec mysqld --user=mysql --init-file=/tmp/init.sql --bind-address=0.0.0.0
