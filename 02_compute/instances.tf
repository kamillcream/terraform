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

resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.services.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/../scripts/install_docker.sh")

  tags = {
    Name        = "${var.env}-public-server"
    Environment = var.env
  }
}

resource "aws_instance" "private" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = one(data.aws_subnets.private.ids)
  vpc_security_group_ids = [aws_security_group.services.id]
  user_data              = file("${path.module}/../scripts/install_docker.sh")

  tags = {
    Name        = "${var.env}-private-server"
    Environment = var.env
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  key_name                    = var.bastion_key_name
  user_data                   = file("${path.module}/../scripts/install_docker.sh")

  tags = {
    Name        = "${var.env}-bastion-host"
    Environment = var.env
  }
}
