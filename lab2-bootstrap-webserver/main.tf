provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_instance" {
  ami                    = "ami-0f34c5ae932e6f0e4" #amazon linux 2
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.web_instance_sg.id]
  user_data              = file("user_data.sh")
  tags = {
    Name  = "Webserver Built by Terraform"
    Owner = "Cloud Jedi"
  }
}

resource "aws_security_group" "web_instance_sg" {
  name        = "web_instance_sgs"
  description = "Allow inbound http and https traffic"

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name  = "Web_Instance_SG"
    Owner = "Cloud Jedi"
  }
}


