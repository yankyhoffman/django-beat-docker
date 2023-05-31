FROM python:3.10.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y libpq-dev build-essential && apt-get clean

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

ARG UID=1000
ARG GID=1000

RUN mkdir /usr/src/var
RUN chown -R $UID:$GID /usr/src/var

WORKDIR /usr/src/app

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
