# test_django_pro

A Django web application project containerized with Docker.

## Tech Stack

- **Python 3.11** with **Django 5.0**
- **SQLite** (default database)
- `django-environ` for environment variable management
- **Docker** (python:3.11-slim base image)

## Requirements

- Python 3.11+
- pip
- Docker (optional, for containerized setup)

## Getting Started

### 1. Clone the repository

```bash
git clone <your-repo-url>
cd test_django_pro
```

### 2. Create and activate a virtual environment

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Apply migrations

```bash
python manage.py migrate
```

### 5. Run the development server

```bash
python manage.py runserver
```

The app will be available at `http://127.0.0.1:8000/`.

## Running with Docker

```bash
docker build -t test_django_pro .
docker run -p 8000:8000 test_django_pro
```

The container exposes port **8000** and starts the Django development server on `0.0.0.0:8000`.

## Project Structure

```
test_django_pro/
├── test_django_pro/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── asgi.py
│   └── wsgi.py
├── manage.py
├── requirements.txt
└── Dockerfile
```

## Configuration

Settings are managed in `test_django_pro/settings.py`.

`ALLOWED_HOSTS` is currently configured for:
- `localhost` and `127.0.0.1` (local development)
- `ur-ec2-publicip` (remote/cloud server)

For production, make sure to:

- Set a secure `SECRET_KEY` — never commit the real key; use environment variables via `django-environ`
- Set `DEBUG = False`
- Restrict `ALLOWED_HOSTS` to your actual domain(s)
- Switch to a production-grade database (e.g. PostgreSQL) — the `libpq-dev` system dependency is already included in the Docker image for this

## Admin

Access the Django admin panel at `/admin/`. Create a superuser with:

```bash
python manage.py createsuperuser
```
