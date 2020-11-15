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
sg_id = module.network.net_sg_webserver_id

}

