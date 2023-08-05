module "network" {
  source = "./modules/network" # path to the network module

  vpc_cidr        = var.vpc_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

# Create Secret
resource "aws_secretsmanager_secret" "ssh_secret" {
  name = "SSHSecret"
}

# Store Public Key in Secret
# Going forward we'll update secret value manually or by other means, so we only add initial key here
resource "aws_secretsmanager_secret_version" "ssh_secret_version" {
  secret_id     = aws_secretsmanager_secret.ssh_secret.id
  secret_string = file("~/.ssh/id_rsa.pub")

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# Call the EC2 module for both public and private instances
module "ec2" {
  source = "./modules/ec2"

  public_ec2_count         = var.public_ec2_count
  public_ec2_ami           = var.public_ec2_ami
  public_ec2_instance_type = var.public_ec2_instance_type
  public_ec2_user_data     = var.public_ec2_user_data
  public_subnet_ids        = module.network.public_subnets

  private_ec2_count         = var.private_ec2_count
  private_ec2_ami           = var.private_ec2_ami
  private_ec2_instance_type = var.private_ec2_instance_type
  private_ec2_user_data     = var.private_ec2_user_data
  private_subnet_ids        = module.network.private_subnets

  vpc_id    = module.network.vpc_id
  secret_id = aws_secretsmanager_secret.ssh_secret.id
  my_ip     = var.my_ip
}
