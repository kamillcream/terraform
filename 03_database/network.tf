data "terraform_remote_state" "network" {
  backend = "local"

  config = {
    path = "${path.module}/../01_network/terraform.tfstate"
  }
}

data "terraform_remote_state" "compute" {
  backend = "local"

  config = {
    path = "${path.module}/../02_compute/terraform.tfstate"
  }
}

data "aws_subnet" "public" {
  id = data.terraform_remote_state.network.outputs.subnet_id
}

data "aws_vpc" "main" {
  id = data.aws_subnet.public.vpc_id
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
