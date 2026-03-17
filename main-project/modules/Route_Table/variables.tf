variable "vpc_id" {
  type = string
}
variable "destination_cidr_block" {
  type = string
}
variable "gateway_id" {
  type = string
}
variable "public_cidr_subnet_id" {
  type = list(string)
}
variable "private_cidr_subnet_id" {
  type = list(string)
}
variable "nat_id" {
  type = list(string)
}