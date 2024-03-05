variable "cidr" {
  type = string
  # default = "10.0.0.0/16"
}

variable "tags" {
  type = map(any)
}

variable "public-subnet-cidr" {
  type = string
}

variable "private-subnet-cidr" {
  type = string
}