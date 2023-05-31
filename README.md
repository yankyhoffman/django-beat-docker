Cross between #python and #devops...

I am trying to set up a celery worker and scheduler using docker compose.

I want to store the schedule file at a separate location but I am getting a permission denied error.

To follow along:
1. Install docker
2. Clone this repo
3. Copy `.env.sample` as `.env` and set respective values
4. Create and migrate the database
```sh
$ docker compose run webapp ./manage.py migrate
```
5. Start all services
```sh
$ docker compose up -d
```

Here is the Dockerfile

```Dockerfile
FROM python:3.10.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y libpq-dev build-essential && apt-get clean

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

RUN mkdir /usr/src/var  # <- Define the directory which will store the schedule file
WORKDIR /usr/src/app

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
```

Here is the docker compose scheduler snippet

```yml
version: "3.9"
services:
  ...
  scheduler:
    image: djbeat:current
    user: "${UID}:${GID}"
    command: [ "celery", "-A", "conf.celery_app", "beat", "--schedule", "/usr/src/var/celerybeat-schedule" ]
    environment:
      ...
    volumes:
      - beatvar:/usr/src/var
    depends_on:
      - redis
volumes:
  beatvar:
```

However when I try to start the scheduler it fails with a permission denied error

```sh
$ docker compose up scheduler
...
scheduler-1  | [WARNING] Shelf.__init__(self, dbm.open(filename, flag), protocol, writeback)
scheduler-1  | [WARNING]   File "/usr/local/lib/python3.10/dbm/__init__.py", line 95, in open
scheduler-1  | [WARNING]
scheduler-1  | [WARNING] return mod.open(file, flag, mode)
scheduler-1  | [WARNING] _gdbm
scheduler-1  | [WARNING] .
scheduler-1  | [WARNING] error
scheduler-1  | [WARNING] :
scheduler-1  | [WARNING] [Errno 13] Permission denied: '/usr/src/var/celerybeat-schedule'
```
