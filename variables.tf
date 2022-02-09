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
        default = ""
}
variable "STACKPATH_CLIENT_SECRET" {
        type = string
        default = ""
}
