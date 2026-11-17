*This project has been created as part of the 42 curriculum by miguel-f*

# Inception - System Administration & Virtualization

## Description
This project aims to broaden knowledge of system administration using Docker. It consists of setting up a small infrastructure composed of different services running inside isolated Docker containers, orchestrated through Docker Compose.

The infrastructure is built strictly according to the 42 Inception subject:
- A Docker container containing **NGINX** with SSL/TLS (port 443 only).
- A Docker container containing **WordPress** + **php-fpm** (without NGINX installed).
- A Docker container containing **MariaDB** (without NGINX installed).
- A dedicated **Docker Network** (`inception_network`) that interconnects all services.
- Two dedicated volumes mapped to `/home/miguel-f/data/wordpress` and `/home/miguel-f/data/mariadb` for data persistence.

---

## Instructions

### Prerequisites
- Operating System: Linux (Debian/Ubuntu recommended)
- Docker Engine & Docker Compose plugin installed
- Sudo privileges to mount host bind volumes

### Setup Domain
Add the local domain mapping to your host `/etc/hosts`:
```bash
sudo echo "127.0.0.1 miguel-f.42.fr" >> /etc/hosts
```

### Environment Configuration
Copy the template `.env.example` to `/home/miguel-f/.env` (or directly into the project root `.env`):
```bash
cp .env.example /home/miguel-f/.env
# Edit the file with your credentials
```

### Running the Project
```bash
# Build images and start all services
make

# Check status of containers
make status

# View live logs
make logs

# Stop services
make down

# Full purge of containers, images, volumes and persistent data
make fclean
```

---

## Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [MariaDB Knowledge Base](https://mariadb.com/kb/en/)
- [WordPress Developer Resources](https://developer.wordpress.org/)
- [WP-CLI Command Reference](https://developer.wordpress.org/cli/commands/)

---

## AI Usage
Artificial Intelligence was used as an interactive technical assistant during the development of this project:
- **Troubleshooting:** Diagnosing Debian Bookworm repository updates, PHP-FPM socket configuration mismatches, and NGINX MIME type handling for static CSS.
- **Refactoring:** Formatting and cleaning shell initialization scripts (`init.sh`, `wordpress.sh`) to adhere to POSIX and secure database practices.
- **Documentation:** Drafting structural markdown documentation (`README.md`, `USER_DOC.md`, `DEV_DOC.md`) conforming to the official 42 evaluation scale guidelines.
