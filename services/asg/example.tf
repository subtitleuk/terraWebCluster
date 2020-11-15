data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "terraformstatebucketbh14b1120"
    key    = "terraformstatefile"
    region = "us-east-1"
  }
}


data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

#Please note that this code expects SSH key pair to exist in default dir under 
#users home directory, otherwise it will fail

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws
  key_name   = "master_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_launch_template" "master_asg_template" {
  name_prefix                          = "master_asg_template"
  image_id                             = "${data.aws_ami.amazon-linux-2.id}"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = "t2.micro"
  key_name                             = "aws_key_pair.master-key.key_name"
  vpc_security_group_ids               = "${data.terraform_remote_state.network.sg_webserver_id}"

  tags = {
    Name = "terraweb"
  }
}

resource "aws_autoscaling_group" "master_asg" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1

  launch_template {
    id      = aws_launch_template.master_asg_template.id
    version = "$Latest"
  }
}
