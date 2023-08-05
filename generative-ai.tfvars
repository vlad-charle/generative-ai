region  = "us-east-1"
profile = "generative-ai"

vpc_cidr        = "10.0.0.0/16"
private_subnets = ["10.0.0.0/18", "10.0.64.0/19", "10.0.96.0/19"]
public_subnets  = ["10.0.128.0/18", "10.0.192.0/19", "10.0.224.0/19"]

public_ec2_count         = 2
public_ec2_ami           = "Amazon"
public_ec2_instance_type = "t2.micro"

private_ec2_count         = 2
private_ec2_ami           = "Amazon"
private_ec2_instance_type = "t2.micro"
