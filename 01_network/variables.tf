variable "aws_region" {
  description = "AWS 배포 리전"
  type        = string
  default     = "ap-northeast-2" # 서울 리전
}

variable "vpc_cidr" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "env" {
  description = "배포 환경 구분"
  type        = string
  default     = "dev"
}
