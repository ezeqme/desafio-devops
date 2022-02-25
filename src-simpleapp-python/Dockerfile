FROM alpine:latest

WORKDIR /app

COPY requirements.txt .

RUN apk add --update --no-cache python3 && ln -s python3 /usr/bin/python

RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

RUN pip install -r requirements.txt

COPY app.py .

CMD ["python", "./app.py"]