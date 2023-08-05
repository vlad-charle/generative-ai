# Output the IDs of the private subnets
output "private_subnets" {
  description = "The IDs of the private subnets"
  value       = [for s in aws_subnet.private : s.id]
}

# Output the IDs of the public subnets
output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = [for s in aws_subnet.public : s.id]
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}
