FROM jenkins/jenkins:lts
# ENV CASC_JENKINS_CONFIG /usr/share/jenkins/jenkins.yaml
# GID currently in use by AWS EC2 Container Service
ENV DOCKER_GID 497

USER root
COPY files/jenkins.yaml /var/jenkins_home/jenkins.yaml
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz && tar --strip-components=1 -xvzf docker-18.06.3-ce.tgz -C /usr/local/bin
RUN groupadd -g ${DOCKER_GID} docker
RUN usermod -G docker jenkins
RUN apt-get update -q
RUN curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python get-pip.py \
    && pip install ecs-deploy awscli

RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

COPY files/InitialConfig.groovy /usr/share/jenkins/ref/init.groovy.d/InitialConfig.groovy
COPY files/plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
USER jenkins
