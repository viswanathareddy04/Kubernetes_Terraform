variable "access_key" {
  default = "XXXXX"
}

variable "secret_key" {
  default = "XXXX"
}

variable "instance_count" {
  default = "3"
}

variable "worker_instance_type" {
  default = "t2.micro"
}

variable "master_instance_type" {
  default = "t2.medium"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "protocol" {
  default = "tcp"
}

variable "ami" {
  type = map(string) 

  default = {
    "us-east-1" = "ami-0ac80df6eff0e70b5"
  }
}
