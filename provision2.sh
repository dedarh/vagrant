sudo apt-get update
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:rquillo/ansible -y
sudo apt-get update 
sudo apt-get install ansible -y
echo "Sleep"
sleep 30s
echo "ansible install"


sudo cat> /etc/ansible/ansible.cfg << "EOF"
[defaults]
ansible_managed = Ansible managed: {file} modified on %Y-%m-%d %H:%M:%S by {uid} on {host}

host_key_checking = False
timeout = 20
transport = ssh

[ssh_connection]
scp_if_ssh = True
ssh_args = -o 'ForwardAgent=true' -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o ControlMaster=auto -o ControlPersist=15m
EOF

sudo cat> /etc/ansible/hosts << "EOF"
[experiments]
13.72.109.164
EOF

sudo mkdir ~/.ssh/
sudo chmod 777 ~/.ssh/
echo "ansible re-config"
sleep 10s
sudo touch ~/.ssh/id_rsa

sudo cat> ~/.ssh/id_rsa << "EOF"
-----BEGIN RSA PRIVATE KEY-----
---- ваш ключ от страданий ----
-----END RSA PRIVATE KEY-----
EOF




sleep 10s
cd ~/.ssh/



sleep 10s
sudo mkdir /etc/ansible/playbooks/
sudo chmod 777 /etc/ansible/playbooks/
sudo touch /etc/ansible/playbooks/setup.yml

sudo cat> ~/.ssh/id_rsa.pub << "EOF"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmZrEorwpJnuaEmSvu0GCjzs0mueA1W4kcVq/5rHQr4thYIydAA0mVe4UPpVZ2+OvSh0NDw/2FU3wEN8nwPzu0M2ZUOOxlIRmlzhDdCD28R0jrFRF1Qfds+h1vgWjSEvNtHt4nKLcqXq+IGZfR3mkNTnpX/UHOjtPKxrMoPKkzQFViKeksM+JKZVy3SZakHUCrMHmVLE90XsaaaZS7T/DnwpuEiccdGEIEjDDXdmufO6Vg2/Tv7od0bz4ZrSRpnKHtJnVWamORUpL+26Wyvagk/j3UG0Ukcbbf7qaHTVJFMSgplbNXzP7i51lN8+9YtbNAnFomuyynMJ6DlVEvTRqh ubuntu@ubuntu-xenial
EOF


sudo chmod 644 ~/.ssh/id_rsa.pub
sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/id_rsa

sudo cat> /etc/ansible/playbooks/setup.yml << "EOF"
---
- hosts: experiments
  remote_user: artem
  tasks:
    - name: Update
      apt: name=default-jdk state=present
      become: true	  
    - name: Install list of packages
      apt: name={{item}} state=present
      with_items:
       - default-jdk
       - default-jre
       - git
       - maven
      become: true
    - name: Update_jenkins
      shell: wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add - 
      become: true
    - name: Update_jenkinsk 2
      shell: echo deb http://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list
      become: true
    - name: Update_jenkinsk 2
      shell: apt-get update && apt-get install -y jenkins
      become: true	
    - name: Update_jenkinsk 3
      shell: cp /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar /usr/bin/jenkins-cli.jar && chmod 777 /usr/bin/jenkins-cli.jar
      become: true	  	  
    - name: restart jenkins 
      shell: service jenkins restart
      become: true
    - name: reconfig jenkins 
      shell: rm /var/lib/jenkins/config.xml && cd /var/lib/jenkins/ && wget https://www.dropbox.com/s/witd5pz14bdadj9/config.xml && chmod 777 /var/lib/jenkins/config.xml
      become: true
    - name: restart jenkins 
      shell: service jenkins restart
      become: true	  
    - name: restart jenkins 
      shell: sleep 30s
      become: true	  
    - name: jenkins git
      shell: java -jar /usr/bin/jenkins-cli.jar -s http://13.72.109.164:8080/ install-plugin git && java -jar /usr/bin/jenkins-cli.jar -s http://13.72.109.164:8080/ install-plugin git-client
      become: true	  
    - name: restart jenkins 
      shell: service jenkins restart && sleep 30s
      become: true	  
    - name: job created 
      shell: cd /usr/bin/ && wget https://www.dropbox.com/s/vuw7tx4xfcabmk2/compile.xml && wget https://www.dropbox.com/s/t0szvyufh04brcv/deploy.xml && wget https://www.dropbox.com/s/6mihye6aoxrgtbw/test.xml
      become: true	
    - name: job sleep 
      shell: sleep 30s
      become: true	  
    - name: job add 
      shell: java -jar /usr/bin/jenkins-cli.jar -s http://13.72.109.164:8080 create-job compile < /usr/bin/compile.xml && java -jar /usr/bin/jenkins-cli.jar -s http://13.72.109.164:8080 create-job deploy < /usr/bin/deploy.xml && java -jar /usr/bin/jenkins-cli.jar -s http://13.72.109.164:8080 create-job test < /usr/bin/test.xml
      become: true	
    - name: job add 
      shell: service jenkins restart
      become: true	  
EOF

sudo ansible-playbook -i /etc/ansible/hosts /etc/ansible/playbooks/setup.yml
