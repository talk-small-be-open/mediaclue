#!/bin/bash

ansible-playbook -i inventory_$1.yml -e customerCode=$1 --ask-become-pass playbook_deploy.yml
