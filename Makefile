build:
	docker build -t django-image .

run:
	docker run -d --name django-app -p 8000:8000 django-image

stop:
	docker stop django-app

start:
	docker start django-app

up:
	docker compose up --build -d

down:
	docker compose down

restart:
	docker compose restart

reload:
	docker exec -i django-app touch /opt/app/reload.trigger

pull:
	git pull

shell:
	docker exec -it django-app /bin/sh

logs:
	docker logs django-app | less +G

uwsgi-log:
	docker exec -i django-app cat /var/log/uwsgi/django.log | less +G

migrate:
	docker exec -i django-app python manage.py makemigrations && docker exec -i django-app python manage.py migrate

migrations:
	docker exec -i django-app python manage.py makemigrations

prune:
	docker system prune -a --volumes -f

reload-nx:
	systemctl reload nginx

get-ssl:
	certbot --nginx -d kwarteng.dev -d www.kwarteng.dev

test-nx:
	nginx -t

edit-site:
	nano /etc/nginx/sites-available/django

error-log:
	less +G /var/log/nginx/error.log

access-log:
	less +G /var/log/nginx/access.log

journal:
	journalctl -xeu nginx.service -r

perm:
	chmod 666 static media
	chmod 666 db.sqlite3


