



resource "aws_subnet" "app-subnet"{
vpc_id= var.vpc_id
cidr_block = var.subnet_cidr_block
availability_zone= var.avil_zone
tags = {

    Name = "${var.envi}-Subnet"
}
}

resource "aws_route_table" "app-route-table"{

vpc_id= var.vpc_id
route {
cidr_block= "0.0.0.0/0"
gateway_id=aws_internet_gateway.app-gateway.id


}
}

resource "aws_internet_gateway" "app-gateway"{

vpc_id= var.vpc_id

tags ={

    Name = "${var.envi}-gateway"
}

}

resource "aws_route_table_association" "rtb-ass"{
subnet_id = aws_subnet.app-subnet.id 
route_table_id = aws_route_table.app-route-table.id
}


