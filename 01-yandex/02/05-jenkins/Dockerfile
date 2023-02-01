FROM jenkins/jenkins:2.361.2-lts-jdk11
USER root

RUN set -x \
	&& curl -fSL "https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz" -o docker.tgz \
	&& tar -xzvf docker.tgz \
	&& mv docker/* /usr/local/bin/ \
	&& rmdir docker \
	&& rm docker.tgz \
	&& docker -v

RUN set -x \
	&& curl -LO https://dl.k8s.io/release/v1.25.0/bin/linux/amd64/kubectl \
	&& install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

COPY plugins /usr/share/jenkins/ref/plugins