`terraform init` 
`terraform validate`
Most importantly, to access the `.tfvars` file: `terraform apply -var-file="aws_keys.tfvars"`
`chmod 600 ephemeral_key.pem`
`terraform output -raw private_key_pem > ephemeral_key.pem` 
`terraform output -raw instance_public_ip`
`ssh -i ./ephemeral_key.pem ec2-user@34.229.241.195`

and clean up:
`terraform destroy -var-file="aws_keys.tfvars"`
`rm ephemeral_key.pem`
