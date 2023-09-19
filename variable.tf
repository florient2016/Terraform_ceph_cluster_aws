#**********
#Pré-requisite:
# This file is a representation of config file
# Field free to update value and parameter
#
#   - Make sure to update default "AwsRegion" and "Availability Zone" value
#             For my testing purpose, i used
#             eu-west-3   ==> Paris region
#             eu-west-3b  ==> corresponding AZ
#   - Ami is not the same depend on your region (Update value accordinly)
#              All operating system based on latest Red Hat OS
#              ami-0d767e966f3458eb5 ==> Reh Hat ami ID on eu-west-3
#   - SSH path location
#               Based on windows operating system my path set to:
#               ~/.ssh/id_rsa.pub   ==> ssh public key for ec2 instance connection
#   - Instance type can be also change
#               t3.medium ==> MasterNode instance type
#           /!\ Only master node will be cost, all client, grafana and node used t2.micro instance type
#**********

variable "AwsRegion" {
  default = "eu-west-3"
  description = "Default AWS region based in Paris"
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