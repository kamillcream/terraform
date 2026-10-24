variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "developer_username" {
  description = "개발자 IAM 사용자 이름"
  type        = string
  default     = "developer"
}

variable "developer_group_name" {
  description = "개발자 권한을 관리할 IAM 그룹 이름"
  type        = string
  default     = "developers"
}
