FROM python:3.7-buster

COPY dudemo-server.py /dudemo-server.py
COPY run.sh /entrypoint.sh

RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir mysql-connector-python

RUN chmod +x /entrypoint.sh

ENTRYPOINT "/entrypoint.sh" 
