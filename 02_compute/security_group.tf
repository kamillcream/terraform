locals {
  service_ports = {
    spring_boot = 8080
    fastapi     = 8000
  }

  allowed_cidr_blocks = length(var.allowed_cidr_blocks) > 0 ? var.allowed_cidr_blocks : toset([data.aws_vpc.main.cidr_block])

  ingress_rules = {
    for pair in setproduct(keys(local.service_ports), local.allowed_cidr_blocks) :
    "${pair[0]}:${pair[1]}" => {
      service = pair[0]
      port    = local.service_ports[pair[0]]
      cidr    = pair[1]
    }
  }
}

resource "aws_security_group" "services" {
  name_prefix = "${var.env}-compute-services-"
  description = "Spring Boot and FastAPI"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name        = "${var.env}-compute-services"
    Environment = var.env
  }
}

resource "aws_vpc_security_group_ingress_rule" "services" {
  for_each = local.ingress_rules

  security_group_id = aws_security_group.services.id
  description       = each.value.service
  cidr_ipv4         = each.value.cidr
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "all_ipv4" {
  security_group_id = aws_security_group.services.id
  description       = "Allow all outbound IPv4 traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_security_group" "bastion" {
  name_prefix = "${var.env}-bastion-"
  description = "SSH access to the bastion host"
  vpc_id      = data.aws_vpc.main.id

  tags = {
    Name        = "${var.env}-bastion"
    Environment = var.env
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  for_each = var.bastion_allowed_cidrs

  security_group_id = aws_security_group.bastion.id
  description       = "SSH from approved admin CIDR"
  cidr_ipv4         = each.value
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "bastion_all_ipv4" {
  security_group_id = aws_security_group.bastion.id
  description       = "Allow outbound IPv4 traffic"
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
