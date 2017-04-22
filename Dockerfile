FROM alpine:3.5

ENV SSH_USER=ansible
ENV SSH_DIR=/home/$SSH_USER/.ssh

RUN apk add --no-cache openssh python && \
    ssh-keygen -A &&\
    addgroup $SSH_USER && \
    adduser $SSH_USER -S -s /bin/sh -G $SSH_USER && \
    passwd -u $SSH_USER && \
    mkdir -p $SSH_DIR && \
    touch $SSH_DIR/authorized_keys && \
    chown -R $SSH_USER:$SSH_USER $SSH_DIR && \
    chmod -R 700 $SSH_DIR && \
    chmod -R 600 $SSH_DIR/authorized_keys && \
    sed -i "s/^#Port 22/Port 22/g" /etc/ssh/sshd_config && \
    sed -i "s/^#PermitRootLogin prohibit-password$/PermitRootLogin no/g" /etc/ssh/sshd_config && \
    sed -i "s/^#PubkeyAuthentication yes$/PubkeyAuthentication yes\nRSAAuthentication yes/g" /etc/ssh/sshd_config && \
    sed -i "s/^AuthorizedKeysFile\t.ssh\/authorized_keys/AuthorizedKeysFile\t%h\/.ssh\/authorized_keys/g" /etc/ssh/sshd_config &&\
    sed -i "s/^#PasswordAuthentication yes$/PasswordAuthentication no/g" /etc/ssh/sshd_config 

ADD entrypoint.sh /

EXPOSE 22

ENTRYPOINT ["/entrypoint.sh"]
