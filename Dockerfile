# =====================================================================
# STAGE 1: Builder
# =====================================================================
FROM python:3.11-slim AS builder
# Prevent Python from writing .pyc files and enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1
WORKDIR /app
# Install system compilation tools needed for C-extensions (e.g., psycopg2, cryptography)
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*
# Create a virtual environment to isolate dependencies cleanly
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
# Install dependencies inside the virtual environment
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
# =====================================================================
# STAGE 2: Runtime (Final Image)
# =====================================================================
FROM python:3.11-slim AS runtime
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"
WORKDIR /app
# Install only the runtime system libraries (no compilers!)
RUN apt-get update && apt-get install --no-install-recommends -y \
    libpq5 \
    && rm -rf /var/lib/apt/lists/*
# Copy the isolated Python environment from the builder stage
COPY --from=builder /opt/venv /opt/venv
# Copy application source code
COPY . .
# Run the application as a secure, non-privileged user
RUN useradd --create-home appuser && chown -R appuser:appuser /app
USER appuser
EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "test_django_pro.wsgi:application"]
 
