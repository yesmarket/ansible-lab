resource "random_string" "this" {
  length  = 7
  special = false
  upper   = false
}

locals {
  #naming_prefix = "lab-${random_string.this.result}"
  naming_prefix = "lab-nbg86dy"
}
