data "aws_ami" "amazon_linux_2_free_tier" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-*-x86_64-gp2"]  
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"]  # Amazon's official AWS AMI owner ID
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_region" {
  default = "us-east-1"  
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_2_free_tier.id
  instance_type = "t2.micro"

  tags = {
    Name = "TerraformEC2Instance"
  }
}

output "instance_public_ip" {
  value = aws_instance.example.public_ip
  description = "The public IP address of the EC2 instance"
}
