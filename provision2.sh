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
MIIEogIBAAKCAQEApmaxKK8KSZ7mhJkr7tBgo87NJrngNVuJHFav+ax0K+LYWCMn
QANJlXuFD6VWdvjr0odDQ8P9hVN8BDfJ8D87tDNmVDjsZSEZpc4Q3Qg9vEdI6xUR
dUH3bPodb4Fo0hLzbR7eJyi3Kl6viBmX0d5pDU56V/1Bzo7TysazKDypM0BVYinp
LDPiSmVct0mWpB1AqzB5lSxPdF7GmmmUu0/w58KbhInHHRhCBIww13ZrnzulYNv0
7+6HdG8+Ga0kaZyh7SZ1VmpjkVKS/tulsr2oJP491BtFJHG23+6mh01SRTEoKZWz
V8z+4udZTfPvWLWzQJxaJrsspzCeg5VRL00aoQIDAQABAoIBAG5Lw0HkRD1oRgO+
Q5CYLnZlrTXuHt8/PTK7gwlLdfVg92X0Zx/XDf83UIt+XEGf3TA+2Cci0fh9zcY9
9Gx6fWiEaV+KG6csuYNdg2/+9mzGE18/J8NBZm+lmb0/WetlBFVgEICETGSZPmBI
FonVkmxviEiqZeQ0Z84Qxs/05XJCMITsQ7V3EVlUOYBPxVVggK7Taj147GLra7Ab
Jmv6sGzKn9EjiXZJS04KhA901uNgcTR1gVhhGdCh/tqusPXTHpoFUYNJ3Y570SEC
d98d1EbAi8ly2aBKFWJpmZqYmdfyvcO+phxCIYsy9wCQ9dHfnLOylZXVrMsVTY6X
Z/yEucECgYEA1oXBRqQQf971V6NBhVKFJHLulkvlmmPlEWLZzDlD7J4LTXf4GAle
5uDFpMx7oeOPsnj8Avc06Ann8TIiNyGIZDb0O0SRu6ZMk+mn7xj6kEWC6JFb1efi
utERUlwx3nGJT1FRBa3no3+ZPjKWlQp+wMlw2r5qpmKNP+eOo6Ou4vMCgYEAxpMR
vfXUVBXJ3MoNgNWpVGvPdZ7frvW+vLFAQemqioOjzn+VlOaK3Ha3ov25+QTMW6JX
wTxROswk9TvCTSYcOs43oLOtRvAPVWC1N3yv1oCYvKOXuEsm2pr8qCgr1TnjH1YS
1axMhjY1GxYJlbEwKqS3dw9tFEQPYEikw96E6RsCgYAC7E2m5cNnyqTzLcFNzMMN
rRc9KwmU4fmUFBG9q6YWSk0DIDhcM3x8juGCjlq86PnjR6y/aZjp9ICZk8JNmAJg
wzLuv89wjCKM/WkRY/i+EIRpINnsfz1iqEihI6p2SnvBfe0ps6XtX2a6JzxQCZWS
kOwdvux7GeqszT3vUuKmKwKBgDb/9SIQPMctYcPtkt/kTgo78jI51uq21iWdUpbv
CXVkELLZU6zyTfPSTfqvHBuE4LVgub2j3zvR30qtSpvjul3vUCkKmyvSwex75LWB
q5JV+/gDt7or1o8l7mUE+18LsYS0anMUTf2+decSq4Tylsy44rfvZd7/GuMoO7qk
n1uRAoGAYZSuRD4YuLysccU6+QZpBJtRdMzNfY9GmLAdYrmNm+pDz0Av30NVPcbI
EI/DtCXkephrgCaWLdf9g5obRZXCV37NPEwgZTNtYAHS8AoYm+U6XvcnrhGeaVbQ
WbG1k+L1TVhWIV9JxPnNyziTUBoMEBtxEuTkpFSnIr63UUKoiig=
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



