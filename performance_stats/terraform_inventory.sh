#!/bin/bash

INSTANCE_IP=$(jq -r '.instance_public_ip.value' < inventory.json)

cat <<EOF
[ec2]
$INSTANCE_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem
EOF
