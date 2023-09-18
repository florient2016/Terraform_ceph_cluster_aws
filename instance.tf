resource "aws_ebs_volume" "manageBlock" {
  availability_zone = var.AvailabilityZone
  size              = 30
  tags = {
    Name= "manageBlock"
  }
}

resource "aws_ebs_volume" "resourceBlock" {
  count = 4
  availability_zone = var.AvailabilityZone
  size              = 30
  tags = {
    Name= "resourceBlock${count.index}"
  }
}

resource "aws_ebs_volume" "resourceBl" {
  count = 4
  availability_zone = var.AvailabilityZone
  size              = var.DiskSizeAttach
  tags = {
    Name= "resourceBl${count.index}"
  }
}

resource "aws_volume_attachment" "ebs_att2" {
  count = 4
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.resourceBlock[count.index].id
  instance_id = aws_instance.worker-node[count.index].id
}

resource "aws_volume_attachment" "ebs_att3" {
  count = 4
  device_name = "/dev/sdg"
  volume_id   = aws_ebs_volume.resourceBl[count.index].id
  instance_id = aws_instance.worker-node[count.index].id
}

resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.manageBlock.id
  instance_id = aws_instance.manage-node.id
}

resource "aws_key_pair" "ceph-key" {
  public_key = file(var.SshPath)
  key_name   = "ceph-key"
}

data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "template_file" "bash" {
  template = file("./bash.sh")
}

data "template_file" "worker" {
  template = file("./worker.sh")
}

resource "aws_instance" "manage-node" {
  instance_type = var.ControlNodeInstanceType
  ami           = var.AmiID
  availability_zone = var.AvailabilityZone
  vpc_security_group_ids      = [aws_security_group.sg-ansible.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.ceph-key.key_name
  tags = {
    Name = "Control-Node"
  }
  user_data = data.template_file.bash.rendered
}

resource "aws_instance" "client" {
  instance_type = var.InstanceType
  ami           = var.AmiID
  availability_zone = var.AvailabilityZone
  vpc_security_group_ids      = [aws_security_group.sg-ansible.id]
  associate_public_ip_address = true
  key_name = aws_key_pair.ceph-key.key_name
  tags = {
    Name = "client"
  }
  user_data = data.template_file.worker.rendered
}

resource "aws_instance" "worker-node" {
  count         = 4
  instance_type = var.InstanceType
  availability_zone = var.AvailabilityZone
  ami           = var.AmiID
  vpc_security_group_ids = [aws_security_group.sg-ansible.id]
  key_name = aws_key_pair.ceph-key.key_name
  user_data = data.template_file.worker.rendered
  tags = {
    Name = "server${count.index}"
  }
}
