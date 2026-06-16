# test_django_pro

A Django web application containerized with Docker using a production-grade multi-stage build.

## Tech Stack

- **Python 3.11** with **Django 5.0**
- **Gunicorn** as the WSGI production server
- **SQLite** (default database)
- `django-environ` for environment variable management
- **Docker** — multi-stage build (python:3.11-slim)

## Requirements

- Docker installed on your server/machine

## How the Docker Build Works

This project uses a **2-stage Docker build** for a smaller, more secure image:

| Stage | Purpose |
|-------|---------|
| **Builder** | Installs build tools and compiles all Python dependencies into a virtual environment |
| **Runtime** | Copies only the virtual environment and app code — no compilers, smaller image |

Additional security: the app runs as a **non-root user** (`appuser`) inside the container.

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

Always pass environment variables using `-e` flags:

```bash
docker run -d -p 8000:8000 --name django_app \
  -e SECRET_KEY=your-secret-key \
  -e DEBUG=False \
  -e ALLOWED_HOSTS=localhost,127.0.0.1,your-server-ip \
  test_django_pro
```

> ⚠️ The app now runs via **Gunicorn** (not Django's dev server). Always set `DEBUG=False` in production.

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

```bash
# Stop and remove the old container
docker rm -f django_app

# Rebuild the image
docker build -t test_django_pro .

# Run with environment variables
docker run -d -p 8000:8000 --name django_app \
  -e SECRET_KEY=your-secret-key \
  -e DEBUG=False \
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
├── Dockerfile            ← multi-stage production build
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
| `DEBUG` | Debug mode — set `False` in production | `False` |
| `ALLOWED_HOSTS` | Comma-separated allowed hosts | `localhost,127.0.0.1,13.234.110.26` |

To generate a secure secret key:

```bash
docker run --rm test_django_pro python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

For production, make sure to:

- Set `DEBUG=False`
- Set a strong, unique `SECRET_KEY`
- Restrict `ALLOWED_HOSTS` to your actual domain(s) — never use `*`
- Switch to a production-grade database (e.g. PostgreSQL) — `libpq5` is already included in the runtime image

## Troubleshooting

### ❌ DisallowedHost Error

**Error:**
```
Invalid HTTP_HOST header: 'your-ip:8000'. You may need to add 'your-ip' to ALLOWED_HOSTS.
```

**Fix:** Stop the container and rerun with the correct IP in `ALLOWED_HOSTS`:

```bash
docker rm -f django_app

docker run -d -p 8000:8000 --name django_app \
  -e SECRET_KEY=your-secret-key \
  -e DEBUG=False \
  -e ALLOWED_HOSTS=localhost,127.0.0.1,your-server-ip \
  test_django_pro
```

### ❌ Gunicorn Not Found / App Won't Start

Make sure `gunicorn` is listed in your `requirements.txt`. Add it if missing:

```
gunicorn
```

Then rebuild the image:

```bash
docker build -t test_django_pro .
```

## Admin

Run database migrations inside the running container:

```bash
docker exec -it django_app python manage.py migrate
```

Create a Django superuser:

```bash
docker exec -it django_app python manage.py createsuperuser
```

Access the admin panel at `http://your-server-ip:8000/admin/`.
