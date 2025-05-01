docker-compose up -d --build

echo "Waiting for Jenkins to start..."

sleep 10

SECRET1=$(curl -s -u admin:admin "http://localhost:8080/computer/agent1/slave-agent.jnlp" \
  | xmllint --xpath '//jnlp/application-desc/argument[1]/text()' -)

SECRET2=$(curl -s -u admin:admin "http://localhost:8080/computer/agent2/slave-agent.jnlp" \
  | xmllint --xpath '//jnlp/application-desc/argument[1]/text()' -)

SECRET3=$(curl -s -u admin:admin "http://localhost:8080/computer/agent3/slave-agent.jnlp" \
  | xmllint --xpath '//jnlp/application-desc/argument[1]/text()' -)

# docker exec -it agent1 java -jar /usr/share/jenkins/agent.jar -url http://jenkins:8080/ -secret $SECRET1 -name agent1 -webSocket -workDir "/home/jenkins/agent"
docker exec -d agent1 sh -c 'java -jar /usr/share/jenkins/agent.jar -url http://jenkins:8080/ -secret '"$SECRET1"' -name agent1 -webSocket -workDir /home/jenkins/agent > /dev/null 2>&1'

docker exec -d agent2 sh -c 'java -jar /usr/share/jenkins/agent.jar -url http://jenkins:8080/ -secret '"$SECRET2"' -name agent2 -webSocket -workDir /home/jenkins/agent > /dev/null 2>&1'

docker exec -d agent3 sh -c 'java -jar /usr/share/jenkins/agent.jar -url http://jenkins:8080/ -secret '"$SECRET3"' -name agent3 -webSocket -workDir /home/jenkins/agent > /dev/null 2>&1'
