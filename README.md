# DevOpsStatelessContainersShopware

This project is part of the **DevOps** learning path of the Shopware Academy.

It shows the reference project state after the practical lab **Preparing Shopware for Stateless Containers**.

It demonstrates how to:

- Extend a local Shopware Docker Compose setup with Valkey and MinIO.
- Configure cache, sessions, and locks with Redis-compatible storage.
- Configure public and private file storage with S3-compatible buckets.
- Keep theme, asset, and sitemap files local for the training setup.
- Use a `.dockerignore` file to keep generated files out of the Docker build context.

Tested for **Shopware 6.7** with the Shopware PHP 8.5 container images.

## Reference Project

This repository is an educational reference state for the Academy practical lab. It is meant for comparing your local result with a known working project state.

You do not need to run this project to use it as a reference. The most important files to compare are:

- `Dockerfile`
- `compose.yaml`
- `.dockerignore`
- `config/packages/stateless.yaml`

These files show the expected Docker image build, Docker Compose runtime setup, build context cleanup, and stateless Shopware configuration at the end of the lab. The `compose.yaml` in this repository extends the reduced learning setup from the previous Docker Compose lab; it is not the generated Shopware CLI development setup.

It is not a production template. The credentials, service names, and runtime settings in `compose.yaml` are intentionally simple for local learning.

## Optional: Run the Project Locally

If you want to run this reference project locally, you still need to build the image, start the containers, create the MinIO buckets, and initialize the local Shopware database. You do not need local PHP or Composer for that; Docker uses the Shopware CLI image during the build.

The Compose setup uses the same host ports as the practical lab:

- `8080` for the Shopware storefront
- `3306` for the MySQL database
- `6379` for Valkey
- `9000` for the MinIO API
- `9001` for the MinIO console

If your own lab project is still running, stop it first from that project directory:

```bash
docker compose down
```

Build the Shopware image:

```bash
docker compose build shopware
```

Start the supporting services first:

```bash
docker compose up -d database redis minio
```

Create the MinIO buckets:

```bash
docker compose run --rm minio-client
```

Start Shopware:

```bash
docker compose up -d shopware
```

Check the running services:

```bash
docker compose ps
```

When the `database` service is healthy and the `shopware` service is running, install Shopware inside the application container:

```bash
docker compose exec -u82 shopware bin/console system:install --basic-setup --create-database --skip-first-run-wizard
```

Compile the theme and clear the HTTP cache:

```bash
docker compose exec shopware bin/console theme:compile
docker compose exec shopware bin/console cache:clear:http
```

Then open the storefront in your browser:

```txt
http://localhost:8080
```

Open the MinIO console in your browser:

```txt
http://localhost:9001
```

Use the local credentials from `compose.yaml`:

```txt
minioadmin / minioadmin
```

If you want to inspect the logs, run:

```bash
docker compose logs -f
```

Stop the setup:

```bash
docker compose down
```

## License

MIT License.

You may use this project in commercial and professional projects.
It is provided as an educational example and comes without a warranty and without support.

## Contributing

This project is part of the Shopware Academy curriculum.
