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
variable "stackpath_stack_id" {
	type = string
}
variable "stackpath_client_id" {
        type = string
        default = ""
}
variable "stackpath_client_secret" {
        type = string
        default = ""
}
