# Random subnet selection for public EC2 instance
resource "random_integer" "public_subnet_index" {
  min = 0
  max = length(var.public_subnet_ids) - 1
}

# Random subnet selection for private EC2 instance
resource "random_integer" "private_subnet_index" {
  min = 0
  max = length(var.private_subnet_ids) - 1
}
data "aws_secretsmanager_secret_version" "public_key" {
  secret_id = var.secret_id
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = data.aws_secretsmanager_secret_version.public_key.secret_string
}

data "aws_ami" "public_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.public_ec2_ami == "Amazon" ? "amzn2-ami-hvm-*-x86_64-gp2" : "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.public_ec2_ami == "Amazon" ? "amazon" : "099720109477"] # Amazon and Canonical (Ubuntu) owner IDs
}

data "aws_ami" "private_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.private_ec2_ami == "Amazon" ? "amzn2-ami-hvm-*-x86_64-gp2" : "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = [var.private_ec2_ami == "Amazon" ? "amazon" : "099720109477"] # Amazon and Canonical (Ubuntu) owner IDs
}

# Security Group for public subnets
resource "aws_security_group" "public_sg" {
  name        = "public_sg"
  description = "Security group for instances in public subnet"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for private subnets
resource "aws_security_group" "private_sg" {
  name        = "private_sg"
  description = "Security group for instances in private subnet"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from public SG"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Public EC2 Instance
resource "aws_instance" "public" {
  count                       = var.public_ec2_count
  ami                         = data.aws_ami.public_ami.id
  instance_type               = var.public_ec2_instance_type
  subnet_id                   = var.public_subnet_ids[random_integer.public_subnet_index.result]
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  key_name                    = aws_key_pair.deployer.key_name
  user_data                   = var.public_ec2_user_data
  associate_public_ip_address = true
  tags = {
    Name = "public-ec2-instance-${count.index}"
  }
}

# Private EC2 Instance
resource "aws_instance" "private" {
  count                  = var.private_ec2_count
  ami                    = data.aws_ami.private_ami.id
  instance_type          = var.private_ec2_instance_type
  subnet_id              = var.private_subnet_ids[random_integer.private_subnet_index.result]
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name               = aws_key_pair.deployer.key_name
  user_data              = var.private_ec2_user_data
  tags = {
    Name = "private-ec2-instance-${count.index}"
  }
}
