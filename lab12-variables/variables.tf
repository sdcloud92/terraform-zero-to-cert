variable "port_list" {
  description = "list of ports to open for out web servers"
  type        = list(string)
  default     = ["80", "443"]
}

variable "instance_type" {
  description = "Instance type used in launch configuration"
  type        = string
  default     = "t2.micro"
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(any)
  default = {
    Owner       = "Cloud Jedi"
    Environment = "Test"
    Project     = "Become a Terraform Boss"
  }
}

variable "aws_region" {
  description = "Region where you want to provision resources"
  type        = string
  default     = "us-east-1"
}
