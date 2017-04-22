#!/bin/bash
ansible-playbook test.yml \
    -i test-target, \
    --ssh-extra-args="-p 2222" \
    -u ansible \
    --key-file=ansible
