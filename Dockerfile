FROM arm64v8/python:3.8-bookworm

RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    build-essential \
    libffi-dev \
    libssl-dev \
    ca-certificates \
 && pip3 install --upgrade setuptools \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

WORKDIR /opt
ADD . /opt/app
WORKDIR /opt/app

RUN python3 setup.py build \
 && python3 setup.py install

ADD docker/run.sh /opt/run.sh

EXPOSE 57575

CMD ["butterfly.server.py", "--unsecure", "--host=0.0.0.0"]
ENTRYPOINT ["docker/run.sh"]
