# version 0.0.1
# docker-version 0.6.6
FROM dockerfile/ubuntu
MAINTAINER  Arthur Neves "arthurnn@gmail.com"

# Make sure the package repository is up to date.
RUN apt-get install -y software-properties-common
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs
RUN apt-get install -y python

RUN	    npm install -g connect socket.io tail 
RUN	    npm install -g coffee-script

RUN	    mkdir /var/log/hb
ADD         hb_cookie /usr/local/bin/
ADD         cozy-logreader /container/web

WORKDIR     /container/web
RUN 	    npm update

EXPOSE	    9099
ENTRYPOINT  ["./start-server"]
CMD         [""]