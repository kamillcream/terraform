output "subnet_id" {
  description = "생성된 퍼블릭 서브넷의 ID"
  value       = aws_subnet.public_1.id
}
