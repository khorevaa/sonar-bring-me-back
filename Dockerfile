FROM maven:3-jdk-8-alpine

RUN mkdir -p /gitrepo

VOLUME /gitrepo
