  variable "env" {
    type = string
    description = "value of the name tag for for all resources"
    default = "final_project"
  
}

variable "vpc_cidr" {
    type = string
    description = "IPv4 cidr block for the VPC"
    default = "10.0.0.0/16"
  
}

variable "public_subnet_cidrs" {
    type = list
    description = "IPv4 cidr block for the public subnet"
    default = ["10.0.1.0/24", "10.0.2.0/24"]
  
}

variable "private_subnet_cidrs" {
    type = list
    description = "IPv4 cidr block for the private subnet"
    default = ["10.0.11.0/24","10.0.33.0/24"]
  
}

# variable "public_subnet_ids" {
#     type = string
#     description = "id of the default public subnet"
#     default = "subnet-0972f7f10bb31a5c5"
  
# }
# variable "private_subnet_ids" {
#     type = string
#     description = "id of the default private subnet"
#     default = "subnet-001069f51229f8c45"
  
# }