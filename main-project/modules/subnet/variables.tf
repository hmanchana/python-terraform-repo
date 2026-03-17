variable "vpc_id" {
  type = string
}
variable "public_cidr_subnet" {
  type = list(string)
}
variable "az" {
  type = list(string
  )
}
variable "private_cidr_subnet" {
  type = list(string)
}