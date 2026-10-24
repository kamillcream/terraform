output "database_instance_id" {
  description = "PostgreSQL EC2 인스턴스 ID"
  value       = aws_instance.postgres.id
}

output "database_private_ip" {
  description = "VPC 내부에서 사용할 PostgreSQL EC2 사설 IP"
  value       = aws_instance.postgres.private_ip
}

output "database_port" {
  description = "PostgreSQL 포트"
  value       = 5432
}

output "database_security_group_id" {
  description = "PostgreSQL EC2에 연결된 보안 그룹 ID"
  value       = aws_security_group.database.id
}

output "database_volume_id" {
  description = "암호화된 PostgreSQL EBS 데이터 볼륨 ID"
  value       = aws_ebs_volume.postgres.id
}
