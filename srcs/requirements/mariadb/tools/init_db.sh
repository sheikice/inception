#!/bin/bash
set -e

# Init first boot
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null
fi

# Start mysqld temp to exec init request
mysqld --user=mysql --skip-networking --socket=/tmp/mysql.sock &
MYSQL_PID=$!

until mysqladmin --socket=/tmp/mysql.sock ping --silent 2>/dev/null; do
    sleep 1
done

# Create base + user from .env vars
mysql --socket=/tmp/mysql.sock -u root << EOF
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    FLUSH PRIVILEGES;
EOF

# stop mysqld temp
kill $MYSQL_PID
wait $MYSQL_PID

# mysqld PID 1
exec mysqld --user=mysql
