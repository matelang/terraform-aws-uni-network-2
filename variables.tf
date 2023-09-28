variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "cidr" {
  type = string
}

variable "azs" {
  type    = list(string)
  default = ["euc1-az1", "euc1-az2", "euc1-az3"]
}
