# Dockerfile
FROM debian:latest

RUN apt-get update \
    && apt-get install -y openssh-server \
    && mkdir /var/run/sshd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && echo "PermitUserEnvironment yes" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]




#############################################################################################


docker build -t my_ssh_container .
docker run -d -p 2222:22 -v /home/s996068:/home/s996068 --name my_ssh_container my_ssh_container

ssh -p 2222 s996068@10.205.10.14

