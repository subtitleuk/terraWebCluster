data "aws_ami" "amazon-linux-2" {
  most_recent      = true
  owners           = ["amazon"]


  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}


resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = "${data.aws_ami.amazon-linux-2.id}"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Latest"
  }
}
