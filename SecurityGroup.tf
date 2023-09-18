resource "aws_security_group" "sg-ansible" {
  name = "ansible-sg"
  ingress {
    description = "Allows ssh connection"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allows ceph cluster connection"
    from_port   = 8443
    protocol    = "tcp"
    to_port     = 8443
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allows ceph cluster connection"
    from_port   = 3000
    protocol    = "tcp"
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allows ssh connection"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["172.31.0.0/16"]
  }
  ingress {
    description = "Allow connection between instance"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = [var.vpc-addr]
  }
  egress {
    description = "Allow external connection"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "SG-ansible"
  }

}