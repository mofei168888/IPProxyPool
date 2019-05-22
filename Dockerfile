FROM daocloud.io/ubuntu:16.04

MAINTAINER Robin<robin.chen@uxsoft.com>

ENV LANG C.UTF-8

RUN  mkdir -p /app

RUN apt-get update

RUN apt-get -y install python2.7 \
     &&  apt-get -y install python-pip \
     && apt-get install python-setuptools \
     && apt-get -y install git \
     && apt-get -y install gcc \
     && apt-get -y install wget


RUN cd /app && git clone https://github.com/mofei168888/IPProxyPool.git

RUN cd /app \
    && wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz \
    && tar zxvf libevent-2.1.8-stable.tar.gz \
    && cd libevent-2.1.8-stable \
    && ls -al \
    && ./configure -prefix=/usr \
    && make \
    && make install

RUN pip install --upgrade pip

RUN pip install --upgrade distribute
RUN apt-get install -y python-lxml

RUN  cd / && find * -name 'chardet*'

#删除老版本的chardet 自动安装新版本
RUN rm -fr /usr/lib/python2.7/dist-packages/chardet-2.0.1.egg-info \
     &&rm -fr  /usr/lib/python2.7/dist-packages/chardet

RUN apt-get install -y python-dev \
    && pip install  greenlet

#安装web.py
RUN pip install web.py
RUN pip install pymysql


WORKDIR /app/IPProxyPool
#安装Python程序运行的依赖库
COPY base.txt /app/IPProxyPool
RUN pip install -r  base.txt


EXPOSE 8010
#CMD echo 'hello world'

ENTRYPOINT ["python", "/app/IPProxyPool/IPProxy.py"]