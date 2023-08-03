output "latest_ubuntu20_ami_id" {
  value = data.aws_ami.latest_ubuntu_20.id
}

output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_windows_2019_ami_id" {
  value = data.aws_ami.latest_windows_2019.id
}
