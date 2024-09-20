terraform {
backend "s3" {
  bucket = "my-app581916614888"
  key = "myapp-state/Terraapp.tfstate"
  region = "us-east-1"

}

}

provider "aws"{
region = "us-east-1"
access_key = ""
secret_key = ""
}



resource "aws_vpc" "my-vpc" {
cidr_block = var.vpc_cidr_block
tags = {
    
    Name = "${var.envi}-vpc"
}
}
#data "aws_vpc" "exisiting-vpc" {
    #default =true
#}
module "myapp-subnet" {

    source = "./modules/subnet"
    vpc_id = aws_vpc.my-vpc.id
    subnet_cidr_block = var.subnet_cidr_block
    avil_zone= var.avil_zone
    envi = var.envi
}
module "myapp-server"{
source = "./modules/server"
vpc_id = aws_vpc.my-vpc.id
my_ip = var.my_ip
envi = var.envi
instance_type = var.instance_type
subnet_id= module.myapp-subnet.subnet-details.id
avil_zone= var.avil_zone
public_key_location = var.public_key_location
}



