resource "aws_iam_user" "developer" {
  name = var.developer_username

  tags = {
    Name      = var.developer_username
    Purpose   = "Development"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_group" "developers" {
  name = var.developer_group_name
}

resource "aws_iam_group_membership" "developer" {
  name  = "${var.developer_group_name}-membership"
  group = aws_iam_group.developers.name
  users = [aws_iam_user.developer.name]
}

# AWS의 개발자용 PowerUserAccess 정책입니다.
# IAM 사용자/그룹/정책 관리 권한은 주지 않지만, 다른 서비스 권한은 폭넓게 허용합니다.
resource "aws_iam_group_policy_attachment" "developer_power_user" {
  group      = aws_iam_group.developers.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}
