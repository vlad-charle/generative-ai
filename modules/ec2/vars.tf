variable "public_ec2_count" {
  description = "Number of EC2 instances to launch in the public subnet"
  type        = number
  default     = 1
}

variable "public_ec2_ami" {
  description = "AMI for the public EC2 instance"
  type        = string
  default     = "ami-0c94855ba95c574c8" # Replace with Amazon Linux AMI in your region
}

variable "public_ec2_instance_type" {
  description = "Instance type for the public EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "public_ec2_user_data" {
  description = "User data to provide when launching the public EC2 instance"
  type        = string
  default     = null
}

variable "public_subnet_ids" {
  description = "Subnet ID for the public EC2 instance"
  type        = list(string)
}

variable "private_ec2_count" {
  description = "Number of EC2 instances to launch in the private subnet"
  type        = number
  default     = 1
}

variable "private_ec2_ami" {
  description = "AMI for the private EC2 instance"
  type        = string
  default     = "ami-0c94855ba95c574c8" # Replace with Amazon Linux AMI in your region
}

variable "private_ec2_instance_type" {
  description = "Instance type for the private EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "private_ec2_user_data" {
  description = "User data to provide when launching the private EC2 instance"
  type        = string
  default     = null
}

variable "private_subnet_ids" {
  description = "Subnet ID for the private EC2 instance"
  type        = list(string)
}
variable "my_ip" {
  description = "My public IP address for SSH access"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EC2 instances will be created"
  type        = string
}

variable "secret_id" {
  description = "SSH key secret ID"
  type        = string
}
