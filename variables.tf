variable "region" {
  description = "AWS region"
  default     = "us-west-1"
}

variable "instance_type" {
  description = "Type of EC2 instance to provision"
  default     = "t2.micro"
}

variable "instance_name" {
  description = "EC2 instance name"
  default     = "Provisioned by Terraform"
}

variable "GOOGLE_CREDENTIALS" {
	type = string
	default = ""
}
variable "STACKPATH_STACK_ID" {
	type = string
        default = ""
}
variable "STACKPATH_CLIENT_ID" {
        type = string
        default = "7d9168f4e89890e6615ce4c4b5d154dd"
}
variable "STACKPATH_CLIENT_SECRET" {
        type = string
        default = "212dd55fb3c8b91a86a3e841e595dc9c1842eebcb0f1076d1429a0ef8c0f3bc1"
}
