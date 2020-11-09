output "vpc_id" {
  value       = aws_vpc.aws-vpc.id
  description = "The name vpc"
}
output "aws_subnet_ids" {
  value       = values(aws_subnet.subnet)[*].id
  description = "The ids subnet"
}
output "aws_security_group_alb" {
  value       = aws_security_group.alb.id
  description = "the security_group id for alb"
}

output "aws_security_group_ecs_tasks" {
  value       = aws_security_group.ecs_tasks.id
  description = "the security_group id for ecs_tasks"
}