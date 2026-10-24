# PostgreSQL EC2

Amazon Linux 2023 EC2의 첫 부팅 때 공통 Docker 설치 스크립트를 실행하고 PostgreSQL 16 컨테이너를 시작합니다.
DB 데이터는 인스턴스와 별도의 암호화된 gp3 EBS 볼륨에 저장합니다.

인스턴스는 `01_network`의 퍼블릭 서브넷에 두고 공인 IP를 할당합니다. DB 보안 그룹은
`02_compute`의 앱 및 Bastion 보안 그룹에서 오는 TCP 5432만 허용하므로, 외부 클라이언트나 SSH 접속은 허용하지 않습니다.
네트워크 구성의 NAT Gateway는 유지하며, NAT Gateway와 공인 IPv4 주소에는 AWS 사용 요금이 발생합니다.

먼저 `01_network`의 인터넷 게이트웨이/NAT 경로와 `02_compute`를 적용해야 합니다.
루트에서 다음 순서로 실행합니다.

```sh
terraform -chdir=01_network apply
terraform -chdir=02_compute apply
export TF_VAR_db_password='강한-비밀번호-입력'
terraform -chdir=03_database init
terraform -chdir=03_database plan
terraform -chdir=03_database apply
unset TF_VAR_db_password
```

기본 EC2 유형은 `t3.micro`, EBS는 20GB입니다. DB 접속 주소는 `database_private_ip` 출력이며,
앱 연결 문자열에는 `:5432/appdb`를 사용합니다. 비밀번호는 EC2 user data를 통해 전달되어 Terraform
state에 기록될 수 있으므로 state 파일 접근 권한을 제한하세요.

EC2를 교체해도 EBS 볼륨은 별도 리소스로 남습니다. 인스턴스를 재생성할 때 기존 볼륨을 보존/재연결할지
확인하고, 사용하지 않는 볼륨은 수동으로 정리하세요.
