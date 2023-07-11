#this file consists of code for instances and sg
provider "aws" {
region = "us-east-1"
access_key = "AKIA24W6HN72B22YS77D"
secret_key = "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"
}

resource "aws_instance" "zoro" {
  ami             = "ami-04823729c75214919"
  instance_type   = "t2.micro"
  key_name        = "zooro"
  vpc_security_group_ids = [aws_security_group.zoro.id]
  availability_zone = "us-east-1a"
  user_data       = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "Hi all this is my app created by terraform infrastructurte on Zoro-server" > /var/www/html/index.html
EOF
  tags = {
    Name = "web-zoro"
  }
}

resource "aws_instance" "nami" {
  ami             = "ami-04823729c75214919"
  instance_type   = "t2.micro"
  key_name        = "zooro"
  vpc_security_group_ids = [aws_security_group.zoro.id]
  availability_zone = "us-east-1b"
  user_data       = <<EOF
#!/bin/bash
sudo -i
yum install httpd -y
systemctl start httpd
chkconfig httpd on
echo "Hai all this is my website created by terraform infrastructurte on Nami-server" > /var/www/html/index.html
EOF
  tags = {
    Name = "web-nami"
  }
}

resource "aws_instance" "sanji" {
  ami             = "ami-04823729c75214919"
  instance_type   = "t2.micro"
  key_name        = "zooro"
  vpc_security_group_ids = [aws_security_group.zoro.id]
  availability_zone = "us-east-1a"
  tags = {
    Name = "app-sanji"
  }
}

resource "aws_instance" "chopper" {
  ami             = "ami-04823729c75214919"
  instance_type   = "t2.micro"
  key_name        = "zooro"
  vpc_security_group_ids = [aws_security_group.zoro.id]
  availability_zone = "us-east-1b"
  tags = {
    Name = "app-chopper"
  }
}

resource "aws_security_group" "zoro" {
  name = "elb-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "zoro-bucket" {
  bucket = "zoro-bucket"
}

resource "aws_iam_user" "zoro-user" {
for_each = var.user_names
name = each.value
}

variable "user_names" {
description = "*"
type = set(string)
default = ["zoro", "nami", "sanji", "chopper"]
}

resource "aws_ebs_volume" "zoro-ebs" {
 availability_zone = "us-east-1a"
  size = 10
  tags = {
    Name = "ebs-zoro"
  }
}
