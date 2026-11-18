FROM ghcr.io/shopware/shopware-cli:latest-php-8.5 AS builder

WORKDIR /app

ENV REDIS_URL=redis://redis:6379
ENV LOCK_DSN=redis://redis:6379/2
ENV S3_ENDPOINT=http://rustfs:9000
ENV S3_PUBLIC_URL=http://localhost:9000/shopware-public
ENV S3_BUCKET=shopware-public
ENV S3_BUCKET_PRIVATE=shopware-private
ENV S3_REGION=eu-central-1
ENV S3_ACCESS_KEY=rustfsadmin
ENV S3_SECRET_KEY=rustfsadmin

COPY composer.json composer.lock ./
RUN composer install --no-interaction --prefer-dist --no-scripts

COPY . .

RUN --mount=type=cache,target=/root/.composer \
    --mount=type=cache,target=/root/.npm \
    if [ -f config/packages/stateless.yaml ]; then mv config/packages/stateless.yaml /tmp/stateless.yaml; fi && \
    /usr/local/bin/entrypoint.sh shopware-cli project ci --force /app && \
    if [ -f /tmp/stateless.yaml ]; then mv /tmp/stateless.yaml config/packages/stateless.yaml; fi

FROM ghcr.io/shopware/docker-base:8.5-frankenphp AS final

WORKDIR /var/www/html

COPY --from=builder --chown=www-data:www-data /app /var/www/html
