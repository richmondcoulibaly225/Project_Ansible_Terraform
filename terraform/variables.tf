variable "vpc_id" {
  description = ""
  type = string
}
variable "public_subnet_cidr" {
  description = ""
  type = string
}
variable "private_subnet_cidr" {
  description = ""
  type = string
}
variable "instance_type" {
  default = "t2.micro"
}
variable "ami_id" {
  description = "ID de l'ami pour ec2"
  type = string
}
