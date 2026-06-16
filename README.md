# test_django_pro

A Django web application project containerized with Docker.

## Tech Stack

- **Python 3.11** with **Django 5.0**
- **SQLite** (default database)
- `django-environ` for environment variable management
- **Docker** (python:3.11-slim base image)

## Requirements

- Docker installed on your server/machine

## Running with Docker

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd test_django_pro
```

### 2. Build the Docker image

```bash
docker build -t test_django_pro .
```

### 3. Run the container

Always pass environment variables using `-e` flags when running the container:

```bash
docker run -d -p 8000:8000 --name django_app \
  -e SECRET_KEY=your-secret-key \
  -e DEBUG=True \
  -e ALLOWED_HOSTS=localhost,127.0.0.1,your-server-ip \
  test_django_pro
```

> ⚠️ **Important:** Never hardcode secrets in `settings.py` or the `Dockerfile`. Always pass them via `-e` flags at runtime.

The app will be available at `http://your-server-ip:8000/`.

### 4. Verify the container is running

```bash
docker ps
```

Look for `django_app` under the `NAMES` column and ensure `STATUS` says `Up`.

### 5. View container logs

```bash
docker logs django_app
```

## Redeploying After Code Changes

Whenever you update your code, rebuild the image and restart the container:

```bash
# Stop and remove the old container
docker rm -f django_app

# Rebuild the image
docker build -t test_django_pro .

# Run with environment variables
docker run -d -p 8000:8000 --name django_app \
  -e SECRET_KEY=your-secret-key \
  -e DEBUG=True \
  -e ALLOWED_HOSTS=localhost,127.0.0.1,your-server-ip \
  test_django_pro
```

## Project Structure

```
test_django_pro/
├── .env.example          ← template showing required environment variables
├── .gitignore
├── manage.py
├── requirements.txt
├── Dockerfile
└── test_django_pro/
    ├── __init__.py
    ├── settings.py
    ├── urls.py
    ├── asgi.py
    └── wsgi.py
```

## Environment Variables

All configuration is passed at runtime via Docker `-e` flags. Never commit secrets to the repository.

| Variable | Description | Example |
|----------|-------------|---------|
| `SECRET_KEY` | Django secret key | `django-insecure-...` |
| `DEBUG` | Debug mode | `True` or `False` |
| `ALLOWED_HOSTS` | Comma-separated allowed hosts | `localhost,127.0.0.1,13.234.110.26` |

To generate a secure secret key:

```bash
docker run --rm test_django_pro python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

For production, make sure to:

- Set `DEBUG=False`
- Restrict `ALLOWED_HOSTS` to your actual domain(s) — never use `*`
- Switch to a production-grade database (e.g. PostgreSQL) — `libpq-dev` is already included in the Docker image

## Troubleshooting

### ❌ DisallowedHost Error

**Error:**
```
Invalid HTTP_HOST header: 'your-ip:8000'. You may need to add 'your-ip' to ALLOWED_HOSTS.
```

**Cause:** Your server's public IP is not included in `ALLOWED_HOSTS`.

**Fix:** Stop the container and rerun it with the correct IP in `ALLOWED_HOSTS`:

```bash
docker rm -f django_app

docker run -d -p 8000:8000 --name django_app \
  -e SECRET_KEY=your-secret-key \
  -e DEBUG=True \
  -e ALLOWED_HOSTS=localhost,127.0.0.1,your-server-ip \
  test_django_pro
```

> For quick testing only, you can set `-e ALLOWED_HOSTS=*` — but **never use this in production**.

## Admin

Create a Django superuser inside the running container:

```bash
docker exec -it django_app python manage.py createsuperuser
```

Run database migrations inside the running container:

```bash
docker exec -it django_app python manage.py migrate
```

Access the admin panel at `http://your-server-ip:8000/admin/`.
