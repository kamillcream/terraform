output "developer_username" {
  description = "생성된 개발자 IAM 사용자 이름"
  value       = aws_iam_user.developer.name
}

output "developer_group_name" {
  description = "개발자 권한이 부여된 IAM 그룹 이름"
  value       = aws_iam_group.developers.name
}
