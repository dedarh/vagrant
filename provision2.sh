echo "apt-get update"
sudo apt-get update

echo "install software-properties-common"
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:rquillo/ansible -y
sudo apt-get update 

echo "install ansible"
sudo apt-get install ansible -y
sleep 30s
echo "install end"

echo "re-config ansible.cfg"
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

echo "re-config ansible hosts"
sudo cat> /etc/ansible/hosts << "EOF"
[experiments]
52.191.214.147
EOF

echo "playbooks ansible"
sudo mkdir /etc/ansible/playbooks/
sudo chmod 777 /etc/ansible/playbooks/

sudo mkdir /etc/ansible/playbooks/tasks/
sudo chmod 777 /etc/ansible/playbooks/tasks/
cd /etc/ansible/playbooks/tasks/
wget https://www.dropbox.com/s/9nyrhf3omzxyne8/setup_with_books.yml
wget https://www.dropbox.com/s/bmpqop48cgf4xm1/jenkins_install.yml
wget https://www.dropbox.com/s/umtoipmk5xqok96/jenkins_restart.yml
wget https://www.dropbox.com/s/kjm7wz2bs01av8v/jenkins_sleep.yml

echo "download playbooks ansible"
cd /etc/ansible/playbooks/
wget https://www.dropbox.com/s/eourmpboi9elf4g/setup.yml

#костыль
#Your identification has been saved in /home/ubuntu/.ssh/id_rsa.
#Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub.

echo "create ssh"
sudo mkdir ~/.ssh/
sudo chmod 777 ~/.ssh/
sleep 10s
echo "download ssh"
sudo cat> ~/.ssh/id_rsa << "EOF"
-----BEGIN RSA PRIVATE KEY-----

-----END RSA PRIVATE KEY-----
EOF

sleep 10s
sudo touch ~/.ssh/id_rsa.pub
sudo cat> ~/.ssh/id_rsa.pub << "EOF"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmZrEorwpJnuaEmSvu0GCjzs0mueA1W4kcVq/5rHQr4thYIydAA0mVe4UPpVZ2+OvSh0NDw/2FU3wEN8nwPzu0M2ZUOOxlIRmlzhDdCD28R0jrFRF1Qfds+h1vgWjSEvNtHt4nKLcqXq+IGZfR3mkNTnpX/UHOjtPKxrMoPKkzQFViKeksM+JKZVy3SZakHUCrMHmVLE90XsaaaZS7T/DnwpuEiccdGEIEjDDXdmufO6Vg2/Tv7od0bz4ZrSRpnKHtJnVWamORUpL+26Wyvagk/j3UG0Ukcbbf7qaHTVJFMSgplbNXzP7i51lN8+9YtbNAnFomuyynMJ6DlVEvTRqh ubuntu@ubuntu-xenial
EOF
sudo chmod 644 ~/.ssh/id_rsa.pub
sudo chmod 700 ~/.ssh/
sudo chmod 600 ~/.ssh/id_rsa



echo "install python in cloud"
#sudo ansible -m shell -a "sudo apt-get update -y" 52.191.214.147 -e "ansible_user=artem" 
#sudo ansible-playbook -i /etc/ansible/hosts /etc/ansible/playbooks/setup.yml
sudo ansible-playbook -i /etc/ansible/hosts /etc/ansible/playbooks/tasks/setup_with_books.yml



