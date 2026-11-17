# User & Administrator Documentation - Inception

This document provides basic instructions for an end user or administrator to access, manage, and verify the Inception web infrastructure.

---

## 1. Accessing the Website

- **Public Website URL:** [https://miguel-f.42.fr](https://miguel-f.42.fr)
- **Protocol:** HTTPS (Port 443 only). Unencrypted HTTP (Port 80) is strictly disabled.
- **Security Note:** When accessing for the first time, your browser will display a security warning regarding a self-signed TLS/SSL certificate. Click **Advanced** and then **Proceed to miguel-f.42.fr**.

---

## 2. Accessing the Administration Panel

- **Admin Login URL:** [https://miguel-f.42.fr/wp-login.php](https://miguel-f.42.fr/wp-login.php)
- **Administrator Username:** Defined in `.env` under `WP_ADMIN` (e.g. `miguelf_master`).
  > *Note: In accordance with the 42 evaluation rules, the administrator username does not contain the word 'admin' or 'Admin'.*
- **Administrator Password:** Defined in `.env` under `WP_ADMIN_PASS`.

---

## 3. Regular User Account (Non-Admin)

- **Username:** Defined in `.env` under `WP_USER` (e.g. `miguelf_author`).
- **Password:** Defined in `.env` under `WP_USER_PASS`.
- **Role:** Author / Editor (cannot modify site settings, themes, or core plugins).

---

## 4. Basic Administration Actions

### Publishing a New Post
1. Log in to the Admin Dashboard at [https://miguel-f.42.fr/wp-login.php](https://miguel-f.42.fr/wp-login.php).
2. Go to **Posts** -> **Add New**.
3. Enter a title and content.
4. Click **Publish**.

### Adding a Comment (Persistence Verification)
1. Navigate to the main page [https://miguel-f.42.fr](https://miguel-f.42.fr).
2. Click on the post **"Welcome to Inception by miguel-f"**.
3. Scroll down to the comment form, type your message, and submit.
4. The comment will immediately appear below the post.

---

## 5. Basic Health Checks

- Verify that all three containers are running:
  ```bash
  docker compose -f ./srcs/docker-compose.yml ps
  ```
- Test HTTPS endpoint via terminal:
  ```bash
  curl -kI https://miguel-f.42.fr
  ```
  *(Expected response: `HTTP/2 200`)*
