#**********
#Pré-requisite:
#   - Make sure to update default "AwsRegion" and Availability Zone depend your preference Region
#**********
variable "AwsRegion" {
  default = "eu-west-3"
  description = "Default AWS region based in Virginia"
}

variable "AvailabilityZone" {
  default = "eu-west-3b"
  description = "Availability zone in which you can deploy your Instance and create volume "
}

variable "AmiID" {
  default = "ami-0d767e966f3458eb5"
  description = "Operating system AMI référence"
}

variable "vpc-addr" {
  description = "network ip address"
  default     = "10.0.0.0/16"
}

variable "SshPath" {
  default = "~/.ssh/id_rsa.pub"
  description = "path for ssh connection"
}

variable "ControlNodeInstanceType" {
  default = "t3.medium"
  description = "Type of instance"
}

variable "InstanceType" {
  default = "t2.micro"
  description = "Type of instance"
}

variable "DiskSizeAttach" {
  default = 20
  description = "External Disk attach to instance in Go"
  type = number
}