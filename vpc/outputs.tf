# This file contains outputs for VPC module #


output "availability_zone" {
    value = data.aws_availability_zones.available.names
}

output "private_subnet" {
    value = aws_subnet.private.*.id
}

output "public_subnet" {
    value = aws_subnet.public.*.id
}

output "aws_ami_id" {
    value = data.aws_ami.ubuntu-18.id
}

output "vpc_cidr" {
    value = aws_vpc.vpc.id
}

output "aws_security_group_consul_servers" {
    value = aws_security_group.consul_servers.id
}

output "aws_security_group_jenkins_master" {
    value = aws_security_group.jenkins_master.id
}

output "aws_security_group_jenkins_slave" {
    value = aws_security_group.jenkins_slave.id
}

output "aws_security_group_all_worker_mgmt" {
    value = aws_security_group.all_worker_mgmt.id
}
