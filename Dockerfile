FROM maven:3-jdk-8-alpine

ENV SONAR_SCANNER_VERSION 3.0.3.778

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

# https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-VERFULL.zip
RUN apk add --no-cache wget && \
	mkdir -p -m 777 /sonar-scanner && \
	wget https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$SONAR_SCANNER_VERSION.zip -O /sonar-scanner/sonar-scanner.zip && \
	cd /sonar-scanner && \
	unzip -q sonar-scanner.zip && \
	rm sonar-scanner.zip

ENV SONAR_SCANNER_HOME=/sonar-scanner/sonar-scanner-$SONAR_SCANNER_VERSION
ENV PATH $PATH:/sonar-scanner/sonar-scanner-$SONAR_SCANNER_VERSION/bin

RUN mkdir -p /gitrepo
RUN mkdir -p /opt/

ADD ./src/history-analyze.sh /opt/history-analyze.sh

RUN chmod +x /opt/history-analyze.sh

VOLUME /gitrepo

WORKDIR /gitrepo

CMD /opt/history-analyze.sh
