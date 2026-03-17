variable "private_cidr_subnet_id" {
  type = list(string)
}
variable "ec2_sg_id" {
  type = string
}
variable "alb_tg_arn" {
  type = string
}
variable "key_name" {
  type = string
}