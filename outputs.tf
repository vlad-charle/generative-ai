# Output details of the public EC2 instances
output "public_instances_details" {
  description = "Details of the public EC2 instances"
  value = {
    for instance in module.ec2.public_instances : instance.id => {
      type       = "Public"
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
      subnet_id  = instance.subnet_id
    }
  }
}

# Output details of the private EC2 instances
output "private_instances_details" {
  description = "Details of the private EC2 instances"
  value = {
    for instance in module.ec2.private_instances : instance.id => {
      type       = "Private"
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
      subnet_id  = instance.subnet_id
    }
  }
}
