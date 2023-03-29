provider "aws" {
  region = "us-east-1"
}
  
data "aws_availability_zones" "az_final_project" {}

resource "aws_vpc" "vpc_final_project" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
   Name = "${var.env}-vpc",
   "kubernetes.io/cluster/${var.env}-cluster" = "shared"
  }

}

resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.vpc_final_project.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = data.aws_availability_zones.az_final_project.names[count.index]
  tags = {
    Name = "${var.env}-public_subnet-${count.index +1}"
     "kubernetes.io/cluster/${var.env}-cluster" = "shared"
    "kubernetes.io/role/elb"                       = 1
  }
   map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "igw_final_project" {
  vpc_id = aws_vpc.vpc_final_project.id

  tags = {
    Name = "${var.env}-igw"
  }
}
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_final_project.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_final_project.id
  }
   tags = {
    Name = "${var.env}-rt_public"
  }
}
resource "aws_route_table_association" "public_routes" {
 count = length(aws_subnet.public_subnet[*].id)
  subnet_id      = element(aws_subnet.public_subnet[*].id, count.index) 
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.vpc_final_project.id
  cidr_block = var.private_subnet_cidrs [count.index]
  availability_zone = data.aws_availability_zones.az_final_project.names [count.index]
  tags = {
    Name = "${var.env}-private_subnet-${count.index +1}"
    "kubernetes.io/cluster/${var.env}-cluster" = "shared"
    "kubernetes.io/role/internal-elb"              = 1

  }
}
 resource "aws_route_table" "rt_private" {
 count = length(var.private_subnet_cidrs) 
   vpc_id = aws_vpc.vpc_final_project.id
     route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_nat_gateway.natgw[count.index].id
   }
    tags = {
    Name = "${var.env}-rt_private-${count.index +1}"
   }
 }
  resource "aws_nat_gateway" "natgw" {
   count = length(var.private_subnet_cidrs)
   allocation_id = aws_eip.eipnatgw[count.index].id
   subnet_id     = element(aws_subnet.private_subnet[*].id, count.index)
   tags = {
     Name = "${var.env}-eipnatgw-${count.index + 1}"
     }
 }
  resource "aws_eip" "eipnatgw" {
   count = length(var.private_subnet_cidrs)
   vpc      = true
   tags = {
     Name = "${var.env}-eipnatgw-${count.index + 1}"

   }
 }
  resource "aws_route_table_association" "private_routes" {
  count = length(aws_subnet.private_subnet[*].id)
   subnet_id      = element(aws_subnet.private_subnet[*].id, count.index) 
   route_table_id = aws_route_table.rt_private[count.index].id
 }

resource "aws_security_group" "public_sg" {
  name   =  "${var.env}-Public-sg"
  vpc_id = aws_vpc.vpc_final_project.id

  tags = {
    Name = "${var.env}-Public-sg"
  }
}

# resource "aws_security_group_rule" "sg_ingress_public_443" {
#   security_group_id = aws_security_group.public_sg.id
#   type              = "ingress"
#   from_port         = 443
#   to_port           = 443
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "sg_ingress_public_80" {
#   security_group_id = aws_security_group.public_sg.id
#   type              = "ingress"
#   from_port         = 80
#   to_port           = 80
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "sg_egress_public" {
#   security_group_id = aws_security_group.public_sg.id
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group" "data_plane_sg" {
#   name   =  "${var.env}-Worker-sg"
#   vpc_id = aws_vpc.vpc_final_project.id

#   tags = {
#     Name = "${var.env}-Worker-sg"
#   }
# }

# resource "aws_security_group_rule" "nodes" {
#   description       = "Allow nodes to communicate with each other"
#   security_group_id = aws_security_group.data_plane_sg.id
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "nodes_inbound" {
#   description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#   security_group_id = aws_security_group.data_plane_sg.id
#   type              = "ingress"
#   from_port         = 1025
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   }

# resource "aws_security_group_rule" "node_outbound" {
#   security_group_id = aws_security_group.data_plane_sg.id
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }


# resource "aws_security_group" "control_plane_sg" {
#   name   = "${var.env}-ControlPlane-sg"
#   vpc_id = aws_vpc.vpc_final_project.id

#   tags = {
#     Name = "${var.env}-ControlPlane-sg"
#   }
# }

# resource "aws_security_group_rule" "control_plane_inbound" {
#   security_group_id = aws_security_group.control_plane_sg.id
#   type              = "ingress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
# }

# resource "aws_security_group_rule" "control_plane_outbound" {
#   security_group_id = aws_security_group.control_plane_sg.id
#   type              = "egress"
#   from_port         = 0
#   to_port           = 65535
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }
