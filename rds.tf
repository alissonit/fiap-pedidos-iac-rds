resource "aws_db_instance" "mysql" {
  allocated_storage      = var.allocated_storage
  db_subnet_group_name   = "cluster"
  db_name                = var.db_name
  identifier             = var.identifier
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.rds_username
  password               = var.rds_password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = true
  vpc_security_group_ids = ["${aws_security_group.rds.id}"]
  tags = {
    Name = "db-${var.app_name}"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-${var.app_name}-sg"
  description = "Security group RDS"
  vpc_id      = data.aws_vpc.cluster.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [data.aws_security_group.cluster.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-${var.app_name}-sg"
  }

}
