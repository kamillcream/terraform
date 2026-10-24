data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "${path.module}/../01_network/terraform.tfstate"
  }
}

# 기존 network의 subnet_id 출력으로 동일한 VPC를 찾습니다.
data "aws_subnet" "public" {
  id = data.terraform_remote_state.network.outputs.subnet_id
}

data "aws_vpc" "main" {
  id = data.aws_subnet.public.vpc_id
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["private-subnet-1"]
  }
}
