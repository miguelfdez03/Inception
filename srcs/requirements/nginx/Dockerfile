FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    openssl \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/miguel-f.42.fr.key \
    -out /etc/nginx/ssl/miguel-f.42.fr.crt \
    -subj "/C=ES/ST=Malaga/L=Malaga/O=42Malaga/OU=Student/CN=miguel-f.42.fr"

COPY conf/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
