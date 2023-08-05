variable "region" {
  description = "The region where AWS operations will take place. Examples are us-east-1, us-west-2, etc."
  type        = string
  default     = "us-east-1" # replace with your default region
}

variable "profile" {
  description = "AWS profile to use for operations"
  type        = string
  default     = "generative-ai"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "public_ec2_count" {
  description = "Number of EC2 instances to launch in the public subnet"
  type        = number
  default     = 1
}

variable "public_ec2_ami" {
  description = "AMI type for public EC2 instances. Accepts 'Amazon' or 'Ubuntu'"
  type        = string
  default     = "Amazon"
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

variable "private_ec2_count" {
  description = "Number of EC2 instances to launch in the private subnet"
  type        = number
  default     = 1
}

variable "private_ec2_ami" {
  description = "AMI type for private EC2 instances. Accepts 'Amazon' or 'Ubuntu'"
  type        = string
  default     = "Amazon"
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

variable "my_ip" {
  description = "My public IP address for SSH access, should be provided on CLI during execution of terraform commands"
  type        = string
}
