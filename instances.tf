#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "ApacheLabAmi" {
  provider = aws.region-lab
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-lab
  key_name   = "apache"
  public_key = file("~/.ssh/id_rsa.pub")
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "ApacheLabInt" {
  provider                    = aws.region-lab
  ami                         = data.aws_ssm_parameter.ApacheLabAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  vpc_security_group_ids      = [aws_security_group.app-sg.id]
  subnet_id                   = aws_subnet.subnet_app.id
  #ecs_associate_public_ip_address = "false"
#  provisioner "local-exec" {
#    command = <<EOF
#aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} \
#&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/install_jenkins.yaml
#EOF
#  }
  tags = {
    Name = "apache_tf"
  }
#  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}

#Create and bootstrap EC2 in us-east-1
resource "aws_instance" "BastionLabInt" {
  provider                    = aws.region-lab
  ami                         = data.aws_ssm_parameter.ApacheLabAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  vpc_security_group_ids      = [aws_security_group.bastion-sg.id]
  subnet_id                   = aws_subnet.subnet_bastion.id
  #ecs_associate_public_ip_address = "true"
#  provisioner "local-exec" {
#    command = <<EOF
#aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-master} --instance-ids ${self.id} \
#&& ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/install_jenkins.yaml
#EOF
#  }
  tags = {
    Name = "bastion_tf"
  }
#  depends_on = [aws_main_route_table_association.set-master-default-rt-assoc]
}
