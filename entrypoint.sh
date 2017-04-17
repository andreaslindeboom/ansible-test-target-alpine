#!/bin/sh
if [ ! -z "$AUTHORIZED_KEY" ]; then
    echo "${AUTHORIZED_KEY}" >> $SSH_DIR/authorized_keys
fi

/usr/sbin/sshd -e -D -f /etc/ssh/sshd_config
