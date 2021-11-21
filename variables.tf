variable "external_ip" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "region-lab" {
  type    = string
  default = "us-east-1"
}
