output "vpc_id" {
  description = "id of the VPC"
  value = aws_vpc.vpc_final_project.id
  
}
 output "vpc_cidr" {
   description = "cidr block of VPC"
   value = aws_vpc.vpc_final_project.cidr_block
  
}
output "public_subnet_ids" {
   description = "id of the public subnet"
   value = aws_subnet.public_subnet.*.id

}
 output "private_subnet_ids" {
   description = "id of thr private subnet"
   value = aws_subnet.private_subnet.*.id

}
# output "public_instance_id" {
#     description = "id of the public intance"
#     value = "aws_instance.final_project_publicinstance"
# }  
# output "private_instance_id" {
#     description = "id of the private intance"
#     value = "aws_instance.final_project_privateinstance"
# }