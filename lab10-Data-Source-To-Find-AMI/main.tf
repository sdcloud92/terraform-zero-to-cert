# resource "aws_instance" "myserver" {
#     ami = "data.aws_ami.latest_ubuntu20.id"
#     instance_type = "t2.micro"
# }

data "aws_ami" "latest_ubuntu_20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"] #Swapped out timestamp for *
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-*-kernel-6.1-x86_64"] #Swapped out timestamp for *
  }
}

data "aws_ami" "latest_windows_2019" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"] #Swapped out timestamp for *
  }
}






