#!/bin/bash

########################
# Jenkins
########################
echo "Installing Jenkins"
apt-get update 
echo "\n---— Installing JDK —----\n" 
apt-get install -y default-jdk 
echo "\n---— Installing JRE —----\n" 
apt-get install -y default-jre 
echo "\n---— Installing GIT —----\n" 
apt-get install -y git 

wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - 
echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list 
sudo apt-get update 
sudo apt-get install -y jenkins 

sudo apt-get install -y maven 

sudo service jenkins restart
echo "Success"

sudo cp /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar /usr/bin/jenkins-cli.jar
sudo chmod +x /usr/bin/jenkins-cli.jar

java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin git
java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin git-client
sudo service jenkins restart

echo "plugin install"
cd /usr/bin/
sudo touch compile.xml
sudo touch deploy.xml
sudo touch test.xml

sudo chmod 777 /usr/bin/compile.xml
sudo chmod 777 /usr/bin/deploy.xml
sudo chmod 777 /usr/bin/test.xml

sudo cat> compile.xml << "EOF" 
<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <scm class="hudson.plugins.git.GitSCM" plugin="git@3.6.4">
    <configVersion>2</configVersion>
    <userRemoteConfigs>
      <hudson.plugins.git.UserRemoteConfig>
        <url>https://github.com/spring-projects/spring-petclinic.git</url>
      </hudson.plugins.git.UserRemoteConfig>
    </userRemoteConfigs>
    <branches> 
      <hudson.plugins.git.BranchSpec>
        <name>*/master</name>
      </hudson.plugins.git.BranchSpec>
    </branches>
    <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
    <submoduleCfg class="list"/>
    <extensions/>
  </scm>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <builders>
    <hudson.tasks.Shell>
      <command>mvn compile</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
EOF

sudo cat> deploy.xml << "EOF" 
<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <scm class="hudson.scm.NullSCM"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <customWorkspace>workspace\petClinic_compile</customWorkspace>
  <builders>
    <hudson.tasks.Shell>
      <command>./mvnw spring-boot:run &amp;
sleep 3m
kill `lsof -t -i:8080`</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
EOF

sudo cat> test.xml << "EOF" 
<?xml version='1.0' encoding='UTF-8'?>
<project>
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties/>
  <scm class="hudson.scm.NullSCM"/>
  <canRoam>true</canRoam>
  <disabled>false</disabled>
  <blockBuildWhenDownstreamBuilding>false</blockBuildWhenDownstreamBuilding>
  <blockBuildWhenUpstreamBuilding>false</blockBuildWhenUpstreamBuilding>
  <triggers/>
  <concurrentBuild>false</concurrentBuild>
  <customWorkspace>workspace/petClinic_compile</customWorkspace>
  <builders>
    <hudson.tasks.Shell>
      <command>mvn test</command>
    </hudson.tasks.Shell>
  </builders>
  <publishers/>
  <buildWrappers/>
</project>
EOF


echo "Job created"
 java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8080 create-job compile < /usr/bin/compile.xml
 java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8080 create-job deploy < /usr/bin/deploy.xml
 java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8080 create-job test < /usr/bin/test.xml
 echo "Job install"
 sudo service jenkins restart
 echo "Success 2"
