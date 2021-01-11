# This file contains information about all EC2 instances #


resource "aws_instance" "consul_server" {
  count                       = 3
  ami                         = module.vpc.aws_ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.vpc.public_subnet[count.index]
  vpc_security_group_ids      = [module.vpc.aws_security_group_consul_servers]
  key_name                    = var.key_name
  associate_public_ip_address = true
  user_data                   = file("../installations/install_consul.sh")
  iam_instance_profile        = aws_iam_instance_profile.auto-join.name
  tags = {
    Name          = "${var.environment_tag}-Consul-Server-${count.index + 1}"
    consul_server = "true"
  }
}


resource "aws_instance" "jenkins_master" {
  count                  = 1
  ami                    = module.vpc.aws_ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet[count.index]
  vpc_security_group_ids = [module.vpc.aws_security_group_jenkins_master]
  key_name               = var.key_name
  associate_public_ip_address = true
  user_data              = file("../installations/install_jenkins.sh")
  tags = {
    Name = "${var.environment_tag}-Jenkins-Master"
  }
}


resource "aws_instance" "jenkins_slave" {
  count                  = 2
  ami                    = module.vpc.aws_ami_id
  instance_type          = var.instance_type
  subnet_id              = module.vpc.private_subnet[count.index]
  vpc_security_group_ids = [module.vpc.aws_security_group_jenkins_slave]
  key_name               = var.key_name
  associate_public_ip_address = true
  user_data              = file("../installations/install_jenkins_agent.sh")
  tags = {
    Name = "${var.environment_tag}-Jenkins-Slave-${count.index + 1}"
  }
}