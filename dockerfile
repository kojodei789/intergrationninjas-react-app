FROM python:3.12-alpine3.23

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system + Python dependencies in ONE layer
RUN apk update && apk add --no-cache \
    gcc \
    musl-dev \
    postgresql-dev \
    xz>=5.8.3-r0 \
    && pip install --upgrade pip \
    && pip install --no-cache-dir gunicorn

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /app/

EXPOSE 8000

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]