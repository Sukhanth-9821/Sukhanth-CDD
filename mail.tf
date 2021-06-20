provider "aws"{
    region= "ap-south-1"
    access_key="AKIA3QRQDQY4H6F4ZDL7"
    secret_key="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"
}
resource "aws_vpc" "ECS_VPC" {
    cidr_block="10.0.0.0/16"
    tags={
        Name="ECS_VPC"
    }
}

resource "aws_subnet" "ECS_public_01"{
    vpc_id=aws_vpc.ECS_VPC.id
    cidr_block= "10.0.1.0/24"
    availability_zone="ap-south-1a"
    map_public_ip_on_launch=true
    tags={
        Name="ECS_public_01"
    }
}

resource "aws_subnet" "ECS_public_02"{
    vpc_id=aws_vpc.ECS_VPC.id
    cidr_block= "10.0.2.0/24"
    availability_zone="ap-south-1b"
    map_public_ip_on_launch=true
    tags={
        Name="ECS_public_02"
    }
}

resource "aws_internet_gateway" "ECS_IGT" {
    vpc_id = aws_vpc.ECS_VPC.id
    tags={
        Name="ECS-IGT"
    }
  
}

resource "aws_route_table" "ECS_Public_RT" {
    vpc_id = aws_vpc.ECS_VPC.id
    route = {
        cidr_block="0.0.0.0/0"
        gateway_id= aws_internet_gateway.ECS_IGT.id
    }
  /* subnet_id= aws_subnet.ECS_public_01.id */
}
 
resource "aws_subnet" "ECS_Private_01"{
    vpc_id=aws_vpc.ECS_VPC.id
    cidr_block= "10.0.3.0/24"
    availability_zone="ap-south-1a"
    tags={
        Name="ECS_Private_01"
    }
}

resource "aws_subnet" "ECS_Private_02"{
    vpc_id=aws_vpc.ECS_VPC.id
    cidr_block= "10.0.4.0/24"
    availability_zone="ap-south-1b"
    tags={
        Name="ECS_Private_02"
    }
}
/* resource "aws_network_interface" "Bastion-interface" {
    subnet_id= aws_subnet.ECS_public_01.id
    attachment {
        instance = aws_instance.Bastion_Host.id
        device_index = 1
    }
} */

resource "aws_instance" "Bastion_Host_2" {
  ami= "ami-0ad704c126371a549"
  key_name = "sukhanth-key-pair"
  instance_type = "t2.micro"
/*   vpc_id=aws_vpc.ECS_VPC.id */
  subnet_id = aws_subnet.ECS_public_01.id
  tags={
      Name="Bastion-Host_2"
  }
}