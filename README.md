# gcr-db-backup

`gcr-db-backup` is a GitHub Container Registry image designed to back up Docker-based PostgreSQL and MariaDB/MySQL databases. The backups are stored in the `/backup` directory.

## Environment Variables

The following environment variables are required:

```sh
DB_HOST=${DB_HOST:-db}
DB_USER=${DB_USER:-user}
DB_PASSWORD=${DB_PASSWORD:-password}
DB_NAME=${DB_NAME:-app_db}
GPG_PASSPHRASE=${GPG_PASSPHRASE}
TEAMS_WEBHOOK=${TEAMS_WEBHOOK}
BACKUP_REPO_URL=${BACKUP_REPO_URL}
```

## Pulling the Image

To pull the image, use one of the following commands:

### Docker

```sh
docker pull ghcr.io/kitechsoftware/db-backup:postgresql-debian
```

### Podman

```sh
podman pull ghcr.io/kitechsoftware/db-backup:postgresql-debian
```

## Other Image Tags

- PostgreSQL (Alpine): `ghcr.io/kitechsoftware/db-backup:postgresql-alpine`
- MariaDB (Alpine): `ghcr.io/kitechsoftware/db-backup:mariadb-alpine`
- MariaDB (Debian): `ghcr.io/kitechsoftware/db-backup:mariadb-debian`