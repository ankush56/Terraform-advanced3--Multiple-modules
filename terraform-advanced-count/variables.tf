# type is optional but good to define as it will help team members
variable "rg_group_names" {
  type        = list(string)
}

variable "resource_group_location" {
}

variable "acr_names" {
  type        = list(string)
}

variable "avengers" {
  type        = list(string)
}

variable "avengers_powers" {
  type        = map(string)
  default     = {
    hulk      = "smash"
    spiderman  = "web"
    thor =  "lighting"
  }
}

