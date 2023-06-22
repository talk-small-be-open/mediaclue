#!/bin/bash

# add --ask-become-pass if sudo needs password
ansible-playbook -i inventory_$1.yml -e customerCode=$1  playbook_install.yml
