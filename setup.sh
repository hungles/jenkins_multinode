# Start all services defined in docker-compose in detached mode and rebuild images
docker-compose up -d --build

# Inform the user that Jenkins is starting
echo "Waiting for Jenkins to start..."

# Wait for Jenkins to fully initialize
sleep 10

# Retrieve the JNLP secret for agent1 from Jenkins API
SECRET1=$(curl -s -u admin:admin "http://localhost:8080/computer/agent1/slave-agent.jnlp" \
  | xmllint --xpath '//jnlp/application-desc/argument[1]/text()' -)

# Retrieve the JNLP secret for agent2 from Jenkins API
SECRET2=$(curl -s -u admin:admin "http://localhost:8080/computer/agent2/slave-agent.jnlp" \
  | xmllint --xpath '//jnlp/application-desc/argument[1]/text()' -)

# Retrieve the JNLP secret for agent3 from Jenkins API
SECRET3=$(curl -s -u admin:admin "http://localhost:8080/computer/agent3/slave-agent.jnlp" \
  | xmllint --xpath '//jnlp/application-desc/argument[1]/text()' -)

# Start agent1 inside the container using the retrieved secret, in the background with output redirected
docker exec -d agent1 sh -c 'java -jar /usr/share/jenkins/agent.jar -url http://jenkins:8080/ -secret '"$SECRET1"' -name agent1 -webSocket -workDir /home/jenkins/agent > /dev/null 2>&1'

# Start agent2 inside the container using the retrieved secret, in the background with output redirected
docker exec -d agent2 sh -c 'java -jar /usr/share/jenkins/agent.jar -url http://jenkins:8080/ -secret '"$SECRET2"' -name agent2 -webSocket -workDir /home/jenkins/agent > /dev/null 2>&1'

# Start agent3 inside the container using the retrieved secret, in the background with output redirected
docker exec -d agent3 sh -c 'java -jar /usr/share/jenkins/agent.jar -url http://jenkins:8080/ -secret '"$SECRET3"' -name agent3 -webSocket -workDir /home/jenkins/agent > /dev/null 2>&1'
