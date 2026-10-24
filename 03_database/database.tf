resource "aws_security_group" "database" {
  name_prefix = "${var.env}-postgres-"
  description = "PostgreSQL access from compute instances"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name        = "${var.env}-postgres"
    Environment = var.env
  }
}

resource "aws_vpc_security_group_ingress_rule" "postgres_from_compute" {
  security_group_id            = aws_security_group.database.id
  description                  = "PostgreSQL from compute security group"
  referenced_security_group_id = data.terraform_remote_state.compute.outputs.security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "postgres_from_bastion" {
  security_group_id            = aws_security_group.database.id
  description                  = "PostgreSQL from bastion host"
  referenced_security_group_id = data.terraform_remote_state.compute.outputs.bastion_security_group_id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "database_all_ipv4" {
  security_group_id = aws_security_group.database.id
  description       = "Allow outbound IPv4 traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "postgres" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.database.id]
  associate_public_ip_address = true
  user_data_replace_on_change = true

  user_data = templatefile("${path.module}/user_data.sh.tftpl", {
    volume_id             = aws_ebs_volume.postgres.id
    db_name               = var.db_name
    db_user               = var.db_username
    db_pass               = var.db_password
    docker_install_script = file("${path.module}/../scripts/install_docker.sh")
  })

  tags = {
    Name        = "${var.env}-postgres"
    Environment = var.env
  }
}

resource "aws_ebs_volume" "postgres" {
  availability_zone = data.aws_subnet.public.availability_zone
  size              = var.volume_size
  type              = "gp3"
  encrypted         = true

  tags = {
    Name        = "${var.env}-postgres-data"
    Environment = var.env
  }
}

resource "aws_volume_attachment" "postgres" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.postgres.id
  instance_id = aws_instance.postgres.id
}
