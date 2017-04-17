#!/bin/bash
ansible-playbook test.yml \
    -i role-tester, \
    --ssh-extra-args="-p 2222" \
    -u ansible \
    --key-file=ansible \
