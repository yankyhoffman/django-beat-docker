FROM python:3.10.11-slim

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install -y libpq-dev build-essential && apt-get clean

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && rm requirements.txt

WORKDIR /usr/src/app
RUN mkdir /usr/src/var

RUN adduser --system --no-create-home webadmin
RUN chown -R webadmin .
RUN chown -R webadmin /usr/src/var

USER webadmin

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
