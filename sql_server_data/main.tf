provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "tls_private_key" "temporary_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ephemeral-key-pair"
  public_key = tls_private_key.temporary_key.public_key_openssh
}

resource "aws_security_group" "sqlserver_sg" {
  name_prefix = "sqlserver-sg-"

  ingress {
    from_port   = 22   # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1433   # SQL Server port
    to_port     = 1433
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Note to RESTRICT in the Real world
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "sqlserver" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ec2_key_pair.key_name
  security_groups = [aws_security_group.sqlserver_sg.name]

  user_data = file("init_script.sh")  # (This installs Docker + SQL Server)

  tags = {
    Name = "SQLServerDockerInstance"
  }
}

output "sqlserver_public_ip" {
  value       = aws_instance.sqlserver.public_ip
  description = "$$ Public IP address of the EC2 instance $$"
}

output "private_key_pem" {
  value       = tls_private_key.temporary_key.private_key_pem
  sensitive   = true
  description = "Private key for SSH access to the EC2 instance"
}