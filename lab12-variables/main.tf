
provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "working" {}
data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"]
  }
}

resource "aws_security_group" "web" {
  name        = "${var.tags["Environment"]}-web_security_group"
  description = "Allow inbound traffic on port 80 & 443 for ${var.tags["Environment"]}-web_security_group "

  dynamic "ingress" {
    for_each = var.port_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, { Name = "${var.tags["Environment"]}-web_security_group" })
}

resource "aws_launch_configuration" "web" {
  name_prefix     = "${var.tags["Environment"]}-WebServer-Highly-Available-LC-"
  image_id        = data.aws_ami.latest_amazon_linux.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.web.id]
  user_data       = file("userdata.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name                 = "ASG-${aws_launch_configuration.web.name}"
  launch_configuration = aws_launch_configuration.web.name
  desired_capacity     = 6
  max_size             = 9
  min_size             = 3
  health_check_type    = "ELB"
  vpc_zone_identifier  = [aws_default_subnet.default_az1.id, aws_default_subnet.default_az2.id]
  load_balancers       = [aws_elb.web.name]

  dynamic "tag" {
    for_each = {
      Name   = "${var.tags["Environment"]}-WebServer in ASG"
      Owner  = "Cloud-Jedi"
      TAGKEY = "TAGVALUE"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "web" {
  name               = "WebServer-HighlyAvailable-ELB"
  availability_zones = [data.aws_availability_zones.working.names[0], data.aws_availability_zones.working.names[1]]
  security_groups    = [aws_security_group.web.id]

  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = merge(var.tags, { Name = "${var.tags["Environment"]}-WebServer-HighlyAvailable-ELB" })
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[0]
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[1]
}


