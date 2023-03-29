# resource "aws_instance" "final_project_publicinstance" {
#   instance_type = var.env == "final_project" ? "t2.micro" : "t3.small"
#   ami = "ami-0aa7d40eeae50c9a9"
#   subnet_id = var.public_subnet_ids
#   //subnet_id = data.terraform_remote_state.final_project-public_subnet.outputs.public_subnet[0]
  
#   tags = {
#     Name = "{var.env}-public_ec2"
#   }
# }