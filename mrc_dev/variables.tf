module "build_wildRydes" {
  # globals
  source   = "../modules"
  app_name = var.app_name
  env      = var.env
  region   = var.region
  lambda_name = var.lambda_name
}

# globals
variable "app_name" {
description = "application name - match app repo"
default     = "wildrydes-mrc053"
}

variable "env" {
description = "deployment environment"
default     = "dev"
}

variable "region" {
description = "region to build environment"
default     = "us-east-2"
}

variable "lambda_name" {
  default = "mrc053_WildRydes_lambdafunc"
}




