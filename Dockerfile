# Multi-stage Dockerfile for Django + Gunicorn
FROM python:3.12-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first for caching
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy project
COPY . /app/

# Expose port 80 for Traefik
EXPOSE 80

# Run with gunicorn on port 80
CMD ["gunicorn", "--bind", "0.0.0.0:80", "--workers", "3", "ecommerce.wsgi:application"]