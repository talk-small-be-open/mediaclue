#!/bin/bash

# add --ask-become-pass if sudo needs password
ansible-playbook --ask-become-pass -i inventory_$1.yml -e customerCode=$1  playbook_install.yml
