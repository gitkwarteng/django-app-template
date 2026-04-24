# Use an official Python runtime based on Debian 12 "bookworm" as a parent image.
FROM python:3.12-slim-bookworm

# Add user that will be used in the container.
# RUN useradd wagtail

USER root

# Port used by this container to serve HTTP.
EXPOSE 8000

# Set environment variables.
# 1. Force Python stdout and stderr streams to be unbuffered.
# 2. Set PORT variable that is used by Gunicorn. This should match "EXPOSE"
#    command.
ENV PYTHONUNBUFFERED=1 \
    PORT=8000

# Install system packages required by Wagtail and Django.
RUN apt-get update --yes --quiet && apt-get install --yes --quiet --no-install-recommends \
    build-essential \
    libpq-dev \
    libmariadb-dev \
    libjpeg62-turbo-dev \
    zlib1g-dev \
    libwebp-dev \
    git \
 && rm -rf /var/lib/apt/lists/*

# Install the application server.
RUN pip install --no-cache-dir uwsgi

# Use /app folder as a directory where the source code is stored.
WORKDIR /opt/app

# Set this directory to be owned by the "wagtail" user. This Wagtail project
# uses SQLite, the folder needs to be owned by the user that
# will be writing to the database file.
# RUN chown wagtail:wagtail /app

# Copy the source code of the project into the container.
#COPY --chown=wagtail:wagtail . /app
COPY . /opt/app

# Install the project requirements.
RUN pip install -r /opt/app/requirements/prod.txt

# Create non-root user
#RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
#USER appuser

# create log directory
RUN mkdir "/var/log/uwsgi/"

# Collect static files.
RUN python manage.py collectstatic --noinput --clear

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]