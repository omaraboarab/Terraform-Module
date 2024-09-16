provider "aws"{
region = "us-east-1"
access_key = "AKIAYO7HO4DULHUQBL7Z"
secret_key = "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"
}

variable "vpc_cidr_block" {}
variable envi{}
variable "subnet_cidr_block" {}
variable "avil_zone"{}
variable "my_ip"{}
variable "instance_type"{}
variable "public_key_location"{}
variable "private_key_loc"{}

resource "aws_vpc" "my-vpc" {
cidr_block = var.vpc_cidr_block
tags = {
    
    Name = "${var.envi}-vpc"
}
}

#data "aws_vpc" "exisiting-vpc" {
    #default =true
#}

resource "aws_subnet" "app-subnet"{
vpc_id= aws_vpc.my-vpc.id
cidr_block = var.subnet_cidr_block
availability_zone= var.avil_zone
tags = {

    Name = "${var.envi}-Subnet"
}
}

#resource "aws_route_table" "app-route-table"{

#vpc_id= aws_vpc.my-vpc.id
#route {
#cidr_block= "0.0.0.0/0"
#gateway_id=aws_internet_gateway.app-gateway.id


#}
#}

resource "aws_internet_gateway" "app-gateway"{

vpc_id= aws_vpc.my-vpc.id

tags ={

    Name = "${var.envi}-gateway"
}

}

#resource "aws_route_table_association" "rtb-ass"{
#subnet_id = aws_subnet.app-subnet.id 
#route_table_id = aws_route_table.app-route-table.id
#}


resource "aws_default_route_table" "main-rtb"{

default_route_table_id = aws_vpc.my-vpc.default_route_table_id
route {
cidr_block= "0.0.0.0/0"
gateway_id=aws_internet_gateway.app-gateway.id
}

tags = {

    Name = "${var.envi}-Main RT"
}
}

resource "aws_security_group" "app-sg"{

name = "Myapp-sg"
vpc_id=aws_vpc.my-vpc.id

ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks= [var.my_ip]
}
ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks= ["0.0.0.0/0"]
}
egress {
from_port= 0
to_port = 0
protocol = "-1"
cidr_blocks= ["0.0.0.0/0"]
prefix_list_ids = []

}
tags = {

    Name = "${var.envi}-SG"
}
}

data "aws_ami" "amazon-linux-image" {

most_recent = true
owners = ["amazon"]
filter {
    name = "name"
    values = ["amzn2-ami-*-x86_64-gp2"]
}
filter{
name = "virtualization-type"
values = ["hvm"]

}
}

output "ami_id" {
value = data.aws_ami.amazon-linux-image.id

}


resource "aws_instance" "myapp-server"{

    ami = data.aws_ami.amazon-linux-image.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.app-subnet.id
    vpc_security_group_ids=[aws_security_group.app-sg.id]
    availability_zone = var.avil_zone
    associate_public_ip_address= true
    key_name = aws_key_pair.ssh-key.key_name
    user_data = <<-EOF
                    #!/bin/bash
                    sudo yum update -y
                    sudo yum install -y docker
                    sudo yum install -y yum-utils
                    sudo usermod -aG docker ec2-user
                    sleep 30
                    sudo systemctl enable docker
                    sudo systemctl start docker
                    sleep 30
                    sudo chmod 666 /var/run/docker.sock
                    sudo chown $USER /var/run/docker.sock
                    sleep 30
                    sudo docker run -p 8080:80 -d nginx
                EOF
    tags = { 
        Name = "${var.envi}-server"
    }
    
}

resource "aws_key_pair" "ssh-key" {
key_name = "appkey"
public_key = file(var.public_key_location)
}

output "my-server-ip"{

    value = aws_instance.myapp-server.public_ip
}

       # sudo chown root:docker /var/run/docker.sock
               # sudo chmod 660 /var/run/docker.sock