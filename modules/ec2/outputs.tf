# Output details of the public EC2 instances
output "public_instances" {
  description = "Details of the public EC2 instances"
  value       = aws_instance.public
}

# Output details of the private EC2 instances
output "private_instances" {
  description = "Details of the private EC2 instances"
  value       = aws_instance.private
}
