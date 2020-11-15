variable "sg_id" {
  description = "Security group ID for connecting the load balancer"
  type        = string
}

variable "sub1_id" {
  description = "Primary availability group subnet - subnet_1"
  type        = string
}


variable "sub2_id" {
  description = "Secondary availability group subnet - subnet_2"
  type        = string
}
variable "elb_id" {
  description = "E. Load Balancer"
  type        = string
}