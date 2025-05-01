FROM jenkins/jenkins:lts

USER root

RUN mkdir -p /home/jenkins/.ssh && \
    chown -R jenkins:jenkins /home/jenkins/.ssh
    
RUN apt-get update && apt-get install -y curl

USER jenkins

COPY casc.yaml /var/jenkins_home/casc.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt