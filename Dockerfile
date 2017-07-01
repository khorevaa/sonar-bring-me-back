FROM maven:3-jdk-8-alpine

RUN mkdir -p /gitrepo
RUN mkdir -p /opt/

ADD ./src/history-analyze.sh /opt/history-analyze.sh

RUN chmod +x /opt/history-analyze.sh

VOLUME /gitrepo

WORKDIR /gitrepo

CMD history-analyze.sh
