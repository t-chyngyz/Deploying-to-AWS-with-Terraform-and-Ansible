# Configure the AWS Provider
provider "aws" {
  region = var.region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Project = "demo-assignment"
    Name    = "DevOpsLab"
  }
}

# Create Public Subnet1
resource "aws_subnet" "pub_sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_sub1_cidr_block
  availability_zone       = var.zone1
  map_public_ip_on_launch = true
  tags = {
    Project = "demo-assignment"
    Name    = "public_subnet1"

  }
}

# Create Public Subnet2

resource "aws_subnet" "pub_sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.pub_sub2_cidr_block
  availability_zone       = var.zone2
  map_public_ip_on_launch = true
  tags = {
    Project = "demo-assignment"
    Name    = "public_subnet2"
  }
}

# Create Private Subnet1
resource "aws_subnet" "prv_sub1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.prv_sub1_cidr_block
  availability_zone       = var.zone1
  map_public_ip_on_launch = false

  tags = {
    Project = "demo-assignment"
    Name    = "private_subnet1"
  }
}

# Create Private Subnet2
resource "aws_subnet" "prv_sub2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.prv_sub2_cidr_block
  availability_zone       = var.zone2
  map_public_ip_on_launch = false

  tags = {
    Project = "demo-assignment"
    Name    = "private_subnet2"
  }
}

resource "aws_db_subnet_group" "RDS_subnet_group" {
name = "mydbsg"
subnet_ids = ["${aws_subnet.prv_sub1.id}", "${aws_subnet.prv_sub2.id}"]
tags = {
Name = "my_database_subnet_group"
}
}

####################################
# Create Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Project = "demo-assignment"
    Name    = "internet gateway"
  }
}

###########################
# Create Public Route Table

resource "aws_route_table" "pub_sub1_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Project = "demo-assignment"
    Name    = "public subnet route table"
  }
}

# Create route table association of public subnet1
resource "aws_route_table_association" "internet_for_pub_sub1" {
  route_table_id = aws_route_table.pub_sub1_rt.id
  subnet_id      = aws_subnet.pub_sub1.id
}

# Create route table association of public subnet2
resource "aws_route_table_association" "internet_for_pub_sub2" {
  route_table_id = aws_route_table.pub_sub1_rt.id
  subnet_id      = aws_subnet.pub_sub2.id
}


#######################################
# Create route table for Private subnet
resource "aws_route_table" "prv_sub1_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Project = "demo-assignment"
    Name    = "private subnet route table"
  }
}


#######################################
#NAT gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.pub_sub1.id
  tags = {
    "Name" = "DummyNatGateway"
  }
}


# Create route table association of public subnet1
resource "aws_route_table_association" "internet_for_priv_sub1" {
  route_table_id = aws_route_table.prv_sub1_rt.id
  subnet_id      = aws_subnet.prv_sub1.id
}

# Create route table association of public subnet2
resource "aws_route_table_association" "internet_for_priv_sub2" {
  route_table_id = aws_route_table.prv_sub1_rt.id
  subnet_id      = aws_subnet.prv_sub2.id
}

#########################################
# Create security group for load balancer

resource "aws_security_group" "elb_sg" {
  name        = var.sg_name
  description = var.sg_description
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.app-port
    to_port     = var.app-port
    protocol    = "tcp"
    description = "HTTP"
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
    Name    = var.sg_tagname
    Project = "demo-assignment"
  }
}

# Create security group for webserver

resource "aws_security_group" "webserver_sg" {
  name        = var.sg_ws_name
  description = var.sg_ws_description
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.app-port
    to_port     = var.app-port
    protocol    = "tcp"
    description = "HTTP"
    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
    from_port   = var.ssh-port
    to_port     = var.ssh-port
    protocol    = "tcp"
    description = "HTTP"
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
    Name    = var.sg_ws_tagname
    Project = "demo-assignment"
  }
}

#######################################
# Create security group for RDS

resource "aws_security_group" "db_sg" {
  name        = var.sg_db_name
  description = var.sg_db_description
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.db-port
    to_port     = var.db-port
    protocol    = "tcp"
    description = "HTTP"
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
    Name    = var.sg_ws_tagname
    Project = "demo-assignment"
  }
}

##################################################
resource "aws_db_instance" "Demo-RDS-tf" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.db-instance-type
  port                   = var.db-port
  vpc_security_group_ids = ["${aws_security_group.db_sg.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.RDS_subnet_group.name}"
  name                   = "mydb"
  identifier             = "mysqldb"
  username               = "myuser"
  password               = "mypassword"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  tags = {
    Name = "my_database_instance"
  }
}


#Get Linux AMI ID using SSM Parameter endpoint
data "aws_ssm_parameter" "ApacheLabAmi" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "BastionUbuntu" {
  name = "/aws/service/canonical/ubuntu/server/20.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
}

#########################################
#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "Bastion-Host" {
  ami                    = "ami-0d527b8c289b4af7f"
  instance_type          = var.instance-type
  key_name               = "aws_key"
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  subnet_id              = aws_subnet.pub_sub1.id

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("${path.module}/aws_key.pem")
    host     = self.public_ip
  }

  tags = {
    Name = "bastion_tf"
  }
  #  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}

################################################################
#Create Launch config
resource "aws_launch_configuration" "webserver-launch-config" {
  name_prefix     = "webserver-launch-config"
  image_id        = data.aws_ssm_parameter.ApacheLabAmi.value
  instance_type   = var.instance-type
  key_name        = "aws_key"
  security_groups = ["${aws_security_group.webserver_sg.id}"]

  root_block_device {
    volume_type = "gp2"
    volume_size = 10
    encrypted   = true
  }

  provisioner "file" { #copy the index file form local to remote
    source      = "index.php"
    destination = "/tmp/index.php"
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("${path.module}/aws_key.pem")
    host = "self.private_ip"
    bastion_host = "${aws_instance.Bastion-Host.public_ip}"
    bastion_user = "ubuntu"
  }
  lifecycle {
    create_before_destroy = true
  }
  user_data = filebase64("${path.module}/init_webserver.sh")
}


# Create Auto Scaling Group
resource "aws_autoscaling_group" "Demo-ASG-tf" {
  name                 = "Demo-ASG-tf"
  desired_capacity     = 1
  max_size             = 2
  min_size             = 1
  force_delete         = true
  depends_on           = [aws_lb.ALB-tf]
  target_group_arns    = ["${aws_lb_target_group.TG-tf.arn}"]
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.webserver-launch-config.name
  vpc_zone_identifier  = ["${aws_subnet.prv_sub1.id}", "${aws_subnet.prv_sub2.id}"]

  tag {
    key                 = "Name"
    value               = "Demo-ASG-tf"
    propagate_at_launch = true
  }
}

# Create Target group
resource "aws_lb_target_group" "TG-tf" {
  name       = "Demo-TargetGroup-tf"
  depends_on = [aws_vpc.main]
  port       = 80
  protocol   = "HTTP"
  vpc_id     = aws_vpc.main.id
  health_check {
    interval            = 70
    path                = "/index.php"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 60
    protocol            = "HTTP"
    matcher             = "200,202"
  }
}

# Create ALB
resource "aws_lb" "ALB-tf" {
  name               = "Demo-ALG-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb_sg.id]
  subnets            = [aws_subnet.pub_sub1.id, aws_subnet.pub_sub2.id]

  tags = {
    name    = "Demo-AppLoadBalancer-tf"
    Project = "demo-assignment"
  }
}

# Create ALB Listener
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ALB-tf.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.TG-tf.arn
  }
}
