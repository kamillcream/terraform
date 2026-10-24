# Compute EC2 및 보안 그룹

`01_network`에서 생성한 로컬 state의 `subnet_id`를 이용해 VPC를 찾고,
퍼블릭 서브넷과 프라이빗 서브넷에 Amazon Linux 2023 EC2를 한 대씩 생성하고,
두 인스턴스에 같은 보안 그룹을 연결합니다. 기본 인스턴스 유형은 `t3.micro`입니다.
보안 그룹은 다음 TCP 포트를 허용합니다.

| 서비스 | 포트 |
| --- | --- |
| Spring Boot | 8080 |
| FastAPI | 8000 |

기본 인바운드는 VPC CIDR에서만 허용하며, 아웃바운드는 모든 IPv4 트래픽을 허용합니다.
서비스의 실제 리스닝 포트가 다르면 `security_group.tf`의 `service_ports`를 수정하세요.

먼저 `01_network`에 적용된 state가 있어야 합니다. 저장소 루트에서 실행합니다.

```sh
terraform -chdir=02_compute init
terraform -chdir=02_compute plan
terraform -chdir=02_compute apply
```

접근 범위를 직접 지정하려면 `02_compute/terraform.tfvars`에 다음과 같이 설정합니다.
설정한 목록은 기본 VPC CIDR을 대체하며, 두 서비스 모두에 적용됩니다.

```hcl
allowed_cidr_blocks = ["10.0.0.0/16", "203.0.113.10/32"] # 외부 IP는 실제 접속 IP로 교체
```

EC2 이미지(AMI)는 AWS 소유의 최신 Amazon Linux 2023 x86_64 이미지를 자동 조회합니다.
프라이빗 서브넷은 `Name = private-subnet-1` 태그로 찾습니다. 프라이빗 인스턴스는 공인 IP를
할당받지 않으며, 이 구성은 NAT Gateway나 SSH 키 페어를 생성하지 않습니다.
또한 퍼블릭 서브넷에 Bastion EC2와 전용 보안 그룹을 생성합니다. Bastion SSH(22)는 기본 차단이며,
`bastion_allowed_cidrs`에 관리용 IP CIDR을 지정해야 허용됩니다. SSH 키 페어는 AWS에 미리 만들어 두고
`bastion_key_name`에 이름을 지정하세요.

```hcl
bastion_allowed_cidrs = ["203.0.113.10/32"] # 실제 관리용 공인 IP로 교체
bastion_key_name      = "my-admin-key"
```

생성 후 `terraform -chdir=02_compute output`으로 Bastion 인스턴스 ID와 공인 IP를 확인할 수 있습니다.

모든 EC2는 첫 부팅 때 `scripts/install_docker.sh`를 user data로 실행해 Docker를 설치하고 시작합니다.
이미 생성된 인스턴스에는 이 스크립트가 자동으로 다시 실행되지 않습니다.
