provider "aws" {
  region = var.region-master
}


module "network" {
  source = "./network"
}

#module "webserver" {
#  source = "./services/webserver"
#}

module "asg" {
  source = "./services/asg"
}

