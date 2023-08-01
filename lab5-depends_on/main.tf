#Using depends_on to determine the order of resource creation by creating dependencies

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_instance" {
  ami                    = "ami-0f34c5ae932e6f0e4" #amazon linux 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  depends_on = [
    aws_instance.app_instance,
    aws_instance.db_instance
  ] #list resources that this resource depends on
  tags = {
    Name  = "Webserver Built by Terraform"
    Owner = "Cloud Jedi"
  }
}

resource "aws_instance" "app_instance" {
  ami                    = "ami-0f34c5ae932e6f0e4" #amazon linux 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  depends_on = [
    aws_instance.db_instance
  ] #list resources that this resource depends on
  tags = {
    Name  = "Appserver Built by Terraform"
    Owner = "Cloud Jedi"
  }
}

resource "aws_instance" "db_instance" {
  ami                    = "ami-0f34c5ae932e6f0e4" #amazon linux 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  tags = {
    Name  = "DBserver Built by Terraform"
    Owner = "Cloud Jedi"
  }
}

resource "aws_security_group" "instance_sg" {
  name        = "instance_sgs"
  description = "Allow inbound http, https, ssh traffic"

  dynamic "ingress" {
    for_each = ["80", "443", "22"] #list of ports we want to create
    content {
      description = "Allowance of ports 80, 443, 22"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name  = "Instance_SG"
    Owner = "Cloud Jedi"
  }
}
