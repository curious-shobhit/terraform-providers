#!/bin/bash

# Step 1: Build Docker container with SSH
cat <<EOF >Dockerfile
FROM debian:latest

RUN apt-get update \
    && apt-get install -y openssh-server \
    && mkdir /var/run/sshd \
    && echo 'root:your_password' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
EOF

docker build -t my_ssh_container .

# Step 2: Run Docker container on the EC2 instance
docker run -d -p 2222:22 --name my_ssh_container my_ssh_container
