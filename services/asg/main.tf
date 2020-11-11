#Get all available AZ's in VPC for master region
data "aws_availability_zones" "azs" {
  provider = aws
  state    = "available"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE AUTO SCALING GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "ags" {
  name                      = "foobar3-terraform-test"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ALB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = aws_launch_configuration.example.id
  vpc_zone_identifier       = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]

  initial_lifecycle_hook {
    name                 = "foobar"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 2000
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

    tag {
      key                 = "Name"
      value               = var.cluster_name
      propagate_at_launch = true
    }
  }
}
