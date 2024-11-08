## Requirements

Write a script `server-stats.sh` that can analyse basic server performance stats. Should be able to run the script on any Linux server and it should provide the following stats:

- Total CPU usage
- Total memory usage (Free vs Used including percentage)
- Total disk usage (Free vs Used including percentage)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

**Stretch goal**: Feel free to optionally add more stats such as os version, uptime, load average, logged in users, failed login attempts etc.

## Working Steps

1) Create `aws_keys.tfvars` and add AWS Access and Secret Keys.
1) `terraform init` and `terraform validate`
2) Apply the configuration with `terraform apply -var-file="aws_keys.tfvars"` 
4) Terraform’s `tls_private_key` and `aws_key_pair` programmatically generate a key pair, use it temporarily, and ensure it’s accessible for Ansible to connect.

`ansible-playbook -i hosts.ini deploy_script.yml`