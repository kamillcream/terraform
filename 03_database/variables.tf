variable "aws_region" {
  description = "AWS 배포 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "env" {
  description = "배포 환경 구분"
  type        = string
  default     = "dev"
}

variable "db_name" {
  description = "초기 생성할 PostgreSQL 데이터베이스 이름"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "마스터 사용자 이름"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "PostgreSQL 사용자 비밀번호 (TF_VAR_db_password로 전달)"
  type        = string
  sensitive   = true

  validation {
    condition     = can(regex("^[A-Za-z0-9_!#$%^&*()+,.=?:-]{8,128}$", var.db_password))
    error_message = "비밀번호는 허용된 영문, 숫자, 기호로 된 8~128자여야 합니다."
  }
}

variable "instance_type" {
  description = "PostgreSQL EC2 인스턴스 유형"
  type        = string
  default     = "t3.micro"
}

variable "volume_size" {
  description = "암호화된 EBS 데이터 볼륨 크기(GB)"
  type        = number
  default     = 20
}
