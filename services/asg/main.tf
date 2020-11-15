# Discover current Amzon linux machine - AMI
###############################################################################

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

###############################################################################
#Please note that this code expects SSH key pair to exist in default dir under 
#users home directory, otherwise it will fail
###############################################################################
#Create key-pair for logging into EC2 in Master VPC
###############################################################################
resource "aws_key_pair" "master-key" {
  provider   = aws
  key_name   = "terrakey"
  public_key = file("~/.ssh/id_rsa.pub")
}

# Create template to launch ASG
###############################################################################
resource "aws_launch_template" "master_asg_template" {
  name_prefix                          = "master_asg_template"
  image_id                             = "${data.aws_ami.amazon-linux-2.id}"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  vpc_security_group_ids               = [var.sg_id]
  key_name                             = "terrakey"


  tags = {
    Name = "terraWeb"
  }
}



# Create autoscaling group
###############################################################################
resource "aws_autoscaling_group" "master_asg" {
  vpc_zone_identifier = [var.sub1_id]
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1

  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.master_asg_template.id
    version = "$Latest"
  }
}
