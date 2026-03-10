# Jenkins + Ansible + Docker Automation Setup

This project demonstrates how to configure **Jenkins with Ansible** in a **Master–Worker architecture** and execute Ansible playbooks from a Jenkins Pipeline.

## System Requirements

| Component | Details |
|-----------|---------|
| Master Node | Ubuntu 24.04 |
| Worker Node | Ubuntu 24.04 |
| Instance Type | t3.small |
| Security Group | Allow All Traffic |
| Terminal Tool | MobaXterm |

Architecture:

Master Node
- Jenkins
- Ansible
- Docker

Worker Node
- Docker
- Java
- Connected as Ansible managed node

---

# Master Node Setup

Login to the master node using **MobaXterm** and switch to root user.

```bash
sudo su -
apt update
```

---

# 1 Install Ansible

```bash
apt install ansible -y
ansible --version
```

---

# 2 Install Java

```bash
apt install openjdk-17-jdk -y
java -version
```

---

# 3 Install Jenkins

```bash
wget -O /usr/share/keyrings/jenkins-keyring.asc \
https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

apt update
apt install jenkins -y
```

Start Jenkins

```bash
systemctl start jenkins
systemctl enable jenkins
systemctl status jenkins
```

Access Jenkins

```
http://MASTER_PUBLIC_IP:8080
```

Get initial password

```bash
cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

# 4 Create Jenkins Pipeline

Inside Jenkins UI

1. Click **New Item**
2. Enter **Project Name**
3. Select **Pipeline**
4. Click **OK**

Then

- Add description
- Configure **Git Repository URL**
- Save and Apply

---

# 5 Install Jenkins Plugin

Navigate to:

```
Manage Jenkins → Plugins
```

Search and install:

```
Pipeline Stage View
```

Restart Jenkins if required.

---

# 6 Configure Jenkins Credentials

Navigate to:

```
Manage Jenkins → Credentials
```

Add new credentials:

- **Kind:** Username and Password
- **Username:** DockerHub Username
- **Password:** DockerHub Password
- **ID:** jenkins-docker

Save the credentials.

---

# 7 Install Docker on Master Node

```bash
apt install docker.io -y
systemctl start docker
systemctl enable docker
docker --version
```

---

# 8 Give Jenkins Docker Permission

Edit sudoers file

```bash
visudo
```

Add the following line:

```
jenkins ALL=(ALL) NOPASSWD: ALL
```

Add Jenkins to Docker group

```bash
usermod -aG docker jenkins
```

Restart Jenkins

```bash
systemctl restart jenkins
```

---

# Worker Node Setup

Login to the worker node.

```bash
sudo su -
apt update
```

---

# 1 Install Java

```bash
apt install openjdk-17-jdk -y
java -version
```

---

# 2 Install Docker

```bash
apt install docker.io -y
systemctl start docker
systemctl enable docker
docker --version
```

---

# 3 Connect Worker Node to Ansible Master

On **Master Node**

Edit inventory file

```bash
nano /etc/ansible/hosts
```

Add worker node IP

```
[worker]
WORKER_PUBLIC_IP
```

---

# 4 Setup SSH Authentication

Generate SSH key on master

```bash
ssh-keygen
```

Copy key to worker node

```bash
ssh-copy-id ubuntu@WORKER_PUBLIC_IP
```

Test connection

```bash
ansible all -m ping
```

Expected output

```
WORKER_PUBLIC_IP | SUCCESS
```

---

# Final Architecture

```
Developer
   |
   |  Git Push
   v
GitHub Repository
   |
   v
Jenkins Pipeline
   |
   v
Ansible Playbook
   |
   v
Worker Node
   |
   v
Docker Container Deployment
```

---

# Outcome

- Jenkins triggers pipeline
- Pipeline executes Ansible playbook
- Playbook runs on worker node
- Docker containers are deployed automatically

---

# Tools Used

- Jenkins
- Ansible
- Docker
- GitHub
- Ubuntu 24.04
- AWS EC2
- MobaXterm

---








<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/af7bcdf5-6d85-48be-87aa-37f70bb71fdb" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/89f504d6-ebad-46aa-b502-eaa71d8bbe26" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/f3c103cb-2b0b-42a0-bb4d-ca18a765a5a2" />



