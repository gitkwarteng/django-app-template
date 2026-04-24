#!/bin/sh

set -xe;

python manage.py makemigrations --noinput

python manage.py migrate --noinput

exec uwsgi --ini uwsgi.ini
