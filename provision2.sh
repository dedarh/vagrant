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
cd ~/.ssh/
wget https://www.dropbox.com/s/zcpqwvhmfiepof4/id_rsa
sleep 10s
cd ~/.ssh/
sleep 10s
sudo mkdir /etc/ansible/playbooks/
sudo chmod 777 /etc/ansible/playbooks/
sudo cat> ~/.ssh/id_rsa.pub << "EOF"
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmZrEorwpJnuaEmSvu0GCjzs0mueA1W4kcVq/5rHQr4thYIydAA0mVe4UPpVZ2+OvSh0NDw/2FU3wEN8nwPzu0M2ZUOOxlIRmlzhDdCD28R0jrFRF1Qfds+h1vgWjSEvNtHt4nKLcqXq+IGZfR3mkNTnpX/UHOjtPKxrMoPKkzQFViKeksM+JKZVy3SZakHUCrMHmVLE90XsaaaZS7T/DnwpuEiccdGEIEjDDXdmufO6Vg2/Tv7od0bz4ZrSRpnKHtJnVWamORUpL+26Wyvagk/j3UG0Ukcbbf7qaHTVJFMSgplbNXzP7i51lN8+9YtbNAnFomuyynMJ6DlVEvTRqh ubuntu@ubuntu-xenial
EOF

sudo chmod 644 ~/.ssh/id_rsa.pub
sudo chmod 700 ~/.ssh
sudo chmod 600 ~/.ssh/id_rsa

cd /etc/ansible/playbooks/
wget  https://www.dropbox.com/s/zpyfj9jrssximmv/setup.yml
sudo ansible-playbook -i /etc/ansible/hosts /etc/ansible/playbooks/setup.yml
