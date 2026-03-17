variable "cidr_block" {
  type = string
}
variable "public_cidr_subnet" {
  type = list(string)
}
variable "az" {
  type = list(string)
}
variable "private_cidr_subnet" {
  type = list(string)
}
variable "destination_cidr_block" {
  type = string
}