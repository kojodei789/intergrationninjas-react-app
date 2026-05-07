FROM python:3.12-alpine3.23

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Alpine uses apk, not apt-get.
# Installs xz 5.8.3-r0 or higher if available in the Alpine repo.
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev \
    xz>=5.8.3-r0

COPY requirements.txt /app/

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install gunicorn

COPY . /app/

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]