# Developer Documentation - Inception

This document provides developer-oriented instructions regarding project architecture, environment setup, Makefile commands, container communication, and data persistence.

---

## 1. Project Architecture

The application is structured following the microservice pattern:
```text
.
├── Makefile                     # Build automation & lifecycle control
├── README.md                    # Project overview & AI usage declaration
├── USER_DOC.md                  # End-user & administrator guide
├── DEV_DOC.md                   # Developer & technical guide
├── .gitignore                   # Excludes .env, secrets, and temp data
├── .env.example                 # Template for required environment variables
└── srcs/
    ├── docker-compose.yml       # Service orchestration definition
    └── requirements/
        ├── mariadb/             # Relational Database service (MariaDB 10.11+)
        │   ├── Dockerfile
        │   ├── conf/mariadb.cnf
        │   └── tools/init.sh
        ├── nginx/               # Reverse Proxy & SSL termination (TLSv1.2/1.3)
        │   ├── Dockerfile
        │   └── conf/nginx.conf
        └── wordpress/           # Application server (PHP-FPM 8.2 + WP-CLI)
            ├── Dockerfile
            └── tools/wordpress.sh
```

---

## 2. Prerequisites & Environment Setup

1. **Required Software:**
   - Linux host system with kernel support for cgroups & namespaces.
   - `docker.io` (Docker Engine >= 20.10)
   - `docker-compose-plugin` (Compose v2)
   - `make`

2. **Host Directory Setup:**
   The volumes require dedicated host directories:
   - `/home/miguel-f/data/mariadb`
   - `/home/miguel-f/data/wordpress`
   *(These are created automatically by the `make` rules).*

3. **Secrets & Environment:**
   Create `/home/miguel-f/.env` with strict permissions:
   ```bash
   cp .env.example /home/miguel-f/.env
   chmod 600 /home/miguel-f/.env
   ```

---

## 3. Makefile Commands

- `make` / `make all` / `make up`: Creates host data directories, builds images if necessary, and starts containers in detached mode.
- `make down`: Gracefully stops and removes containers and networks without deleting volume data.
- `make re`: Performs `make down` followed by `make up`.
- `make status`: Lists running containers and health/port status.
- `make logs`: Streams merged live logs from all containers.
- `make clean`: Prunes dangling and unused Docker objects.
- `make fclean`: Performs full cleanup: stops containers, removes custom images, drops volumes, and wipes `/home/miguel-f/data/*`.

---

## 4. Container Communication & Network

- **Network:** `inception_network` (bridge driver).
- **DNS Resolution:** Docker's internal DNS automatically resolves service names:
  - NGINX connects to WordPress on `wordpress:9000` via FastCGI.
  - WordPress connects to MariaDB on `mariadb:3306` via TCP.
- **Port Exposure:**
  - MariaDB exposes port `3306` internally to the network only.
  - WordPress exposes port `9000` internally to the network only.
  - NGINX binds port `443:443` to the host. No other ports are exposed externally.

---

## 5. Database Direct Access & Diagnostics

To inspect the database manually during development or defense:
```bash
# Open interactive shell in MariaDB container
docker exec -it mariadb bash

# Connect to database using CLI client
mariadb -u ${DB_USER} -p${DB_USER_PASS} ${DB_NAME}

# Useful SQL Queries:
SHOW TABLES;
SELECT ID, user_login, user_email FROM wp_users;
SELECT comment_ID, comment_author, comment_content FROM wp_comments;
```

---

## 6. Live Configuration Modification (Defense Drill)

If an evaluator asks to alter a service port (e.g. change NGINX host port from `443` to `8443`):
1. In `srcs/docker-compose.yml`, edit the ports mapping under `nginx`:
   ```yaml
   ports:
     - "8443:443"
   ```
2. Re-apply the configuration:
   ```bash
   make up
   ```
3. Verify access via: `https://miguel-f.42.fr:8443`.
