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

variable "allowed_cidr_blocks" {
  description = "서비스 포트에 접근 가능한 IPv4 CIDR 목록. 빈 목록이면 VPC CIDR만 허용합니다."
  type        = set(string)
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for cidr in var.allowed_cidr_blocks : can(cidrnetmask(cidr))])
    error_message = "유효한 IPv4 CIDR을 입력하세요. 단일 IP는 /32를 사용합니다."
  }
}

variable "instance_type" {
  description = "EC2 인스턴스 유형"
  type        = string
  default     = "t3.micro"
}

variable "bastion_allowed_cidrs" {
  description = "Bastion SSH(22)를 허용할 관리용 IPv4 CIDR 목록. 빈 목록이면 SSH 인바운드를 만들지 않습니다."
  type        = set(string)
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for cidr in var.bastion_allowed_cidrs : can(cidrnetmask(cidr))])
    error_message = "유효한 IPv4 CIDR을 입력하세요. 단일 IP는 /32를 사용합니다."
  }
}

variable "bastion_key_name" {
  description = "Bastion SSH 접속에 사용할 기존 EC2 키 페어 이름"
  type        = string
  default     = null
  nullable    = true
}
