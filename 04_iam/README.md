# Developer IAM user

개발자 IAM 사용자 한 명을 `developers` 그룹에 넣고 AWS 관리형 `PowerUserAccess` 정책을 연결합니다.
이 정책은 대부분의 AWS 서비스 리소스 생성/수정 권한을 주지만 IAM 사용자, 그룹, 정책 관리는 허용하지 않습니다.
따라서 EC2/VPC 등의 개발 리소스 작업에 사용할 수 있지만 권한이 넓고 과금이 발생하는 리소스도 만들 수 있습니다.

```sh
terraform -chdir=04_iam init
terraform -chdir=04_iam plan
terraform -chdir=04_iam apply
```

이 구성은 장기 액세스 키나 콘솔 비밀번호를 만들지 않습니다. 생성된 IAM 사용자에는 로그인 자격 증명이 없으므로,
실제 사람의 AWS 접속에는 AWS IAM Identity Center와 임시 자격 증명을 우선 사용하세요. IAM 사용자가 반드시 필요한
환경이라면 계정 관리자가 MFA를 포함한 로그인 방식을 별도로 설정하고, 액세스 키를 Terraform state에 저장하지 마세요.
