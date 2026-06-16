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

### 4. Set up environment variables

Copy the example env file and fill in your values:

```bash
cp .env.example .env
```

Your `.env` file should look like this:

```
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1
```

To generate a secure secret key:

```bash
python -c "from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())"
```

### 5. Apply migrations

```bash
python manage.py migrate
```

### 6. Run the development server

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

> **Note:** Make sure your `.env` file exists on the host before running the container, or pass environment variables using `-e` flags:
> ```bash
> docker run -p 8000:8000 \
>   -e SECRET_KEY=your-key \
>   -e DEBUG=True \
>   -e ALLOWED_HOSTS=localhost,127.0.0.1 \
>   test_django_pro
> ```

## Project Structure

```
test_django_pro/
├── .env                  ← secret, never commit
├── .env.example          ← safe to commit, template for .env
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

## Configuration

Settings are managed via environment variables using `django-environ`. All secrets are stored in a `.env` file which is **never committed to version control**.

| Variable | Description | Example |
|----------|-------------|---------|
| `SECRET_KEY` | Django secret key | `django-insecure-...` |
| `DEBUG` | Debug mode | `True` or `False` |
| `ALLOWED_HOSTS` | Comma-separated allowed hosts | `localhost,127.0.0.1` |

`ALLOWED_HOSTS` is configured for:
- `localhost` and `127.0.0.1` (local development)
- `13.234.110.26` (remote/cloud server)

For production, make sure to:

- Set `DEBUG=False` in your `.env`
- Restrict `ALLOWED_HOSTS` to your actual domain(s)
- Switch to a production-grade database (e.g. PostgreSQL) — the `libpq-dev` system dependency is already included in the Docker image for this

## Admin

Access the Django admin panel at `/admin/`. Create a superuser with:

```bash
python manage.py createsuperuser
```

python manage.py createsuperuser
```
