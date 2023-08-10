variable "AZs" {
  type    = list(string)
  default = []
}
variable "public_subnets" {
  type    = list(map(any))
  default = []
}

variable "private_subnets" {
  type    = list(map(any))
  default = []
}

variable "ami" {
  type    = string
  default = "ami-09988af04120b3591"
}

variable "ec2-names-1" {
  type    = list(string)
  default = []
}
variable "ec2-names-2" {
  type    = list(string)
  default = []
}
variable "instance" {
  type = map(string)
  default = {}
}
