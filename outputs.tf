output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "IDs of private subnets"
}

output "auto_scaling_group_name" {
  value       = aws_autoscaling_group.ec2_asg.name
  description = "Name of the Auto Scaling Group"
}

output "ec2_instance_ids" {
  value       = aws_instance.ec2[*].id
  description = "EC2 instance IDs in ASG (if manually managed)"
}

output "iam_role_name" {
  value       = aws_iam_role.ec2_role.name
  description = "IAM role assigned to EC2 instances"
}

output "security_group_id" {
  value       = aws_security_group.ec2_sg.id
  description = "Security Group ID for EC2"
}
