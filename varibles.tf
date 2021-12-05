variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "default region"
}

variable "zone1" {
  type    = string
  default = "eu-central-1a"
}

variable "zone2" {
  type    = string
  default = "eu-central-1b"
}

variable "vpc_cidr" {
  type        = string
  default     = "172.16.0.0/16"
  description = "default vpc_cidr_block"
}

variable "pub_sub1_cidr_block" {
  type    = string
  default = "172.16.1.0/24"
}

variable "pub_sub2_cidr_block" {
  type    = string
  default = "172.16.2.0/24"
}
variable "prv_sub1_cidr_block" {
  type    = string
  default = "172.16.3.0/24"
}
variable "prv_sub2_cidr_block" {
  type    = string
  default = "172.16.4.0/24"
}


variable "sg_name" {
  type    = string
  default = "alb_sg"
}

variable "sg_description" {
  type    = string
  default = "SG for application load balancer"
}

variable "sg_tagname" {
  type    = string
  default = "SG for ALB"
}

variable "sg_ws_name" {
  type    = string
  default = "webserver_sg"
}

variable "sg_db_name" {
  type    = string
  default = "RDS_sg"
}

variable "sg_ws_description" {
  type    = string
  default = "SG for web server"
}

variable "sg_db_description" {
  type    = string
  default = "SG for RDS server"
}

variable "sg_ws_tagname" {
  type    = string
  default = "SG for web"
}

variable "profile" {
  type    = string
  default = "default"
}

variable "instance-type" {
  type    = string
  default = "t2.micro"
}

variable "db-instance-type" {
  type    = string
  default = "db.t2.micro"
}

variable "app-port" {
  type    = number
  default = 80
}

variable "db-port" {
  type    = number
  default = 3306
}

variable "ssh-port" {
  type    = number
  default = 22
}
