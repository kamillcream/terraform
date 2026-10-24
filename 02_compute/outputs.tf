output "security_group_id" {
  description = "EC2 등의 vpc_security_group_ids에 연결할 서비스 보안 그룹 ID"
  value       = aws_security_group.services.id
}

output "public_instance_id" {
  description = "퍼블릭 서브넷 EC2 인스턴스 ID"
  value       = aws_instance.public.id
}

output "public_instance_ip" {
  description = "퍼블릭 EC2의 공인 IPv4 주소"
  value       = aws_instance.public.public_ip
}

output "private_instance_id" {
  description = "프라이빗 서브넷 EC2 인스턴스 ID"
  value       = aws_instance.private.id
}

output "bastion_instance_id" {
  description = "Bastion EC2 인스턴스 ID"
  value       = aws_instance.bastion.id
}

output "bastion_public_ip" {
  description = "Bastion EC2의 공인 IPv4 주소"
  value       = aws_instance.bastion.public_ip
}

output "bastion_security_group_id" {
  description = "Bastion 전용 보안 그룹 ID"
  value       = aws_security_group.bastion.id
}
