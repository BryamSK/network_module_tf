output "vpc_id" {
  value       = aws_vpc.aws-vpc.id
  description = "The name vpc"
}
output "aws_subnet_ids" {
  value       = values(aws_subnet.subnet)[*].id
  description = "The ids subnet"
}