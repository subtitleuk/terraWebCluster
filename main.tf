provider "aws" {
  region = var.region-master
}


module "network" {
  source = "./network"
}

module "asg" {
  source  = "./services/asg"
  sg_id   = module.network.net_sg_webserver_id
  sub1_id = module.network.net_subnet_1_id
  sub2_id = module.network.net_subnet_2_id
}
