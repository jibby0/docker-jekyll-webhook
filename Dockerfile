FROM ubuntu:focal
MAINTAINER Josh Bicking (me@jibby.org)

# Install required software
RUN export DEBIAN_FRONTEND="noninteractive" && \
    apt-get update && \
    apt-get install -y git nginx npm ruby-full build-essential zlib1g-dev ruby-dev

RUN npm install -g github-webhook
RUN gem install bundler

# Configure installed software
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Add configuration files & scripts
COPY * /
RUN mkdir /source /site && \
    chmod +x /*.sh

EXPOSE 80

ENV TZ=America/New_York
CMD ["/run.sh"]

