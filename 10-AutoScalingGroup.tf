

resource "aws_autoscaling_group" "app1_asg-Japan" {
  name_prefix           = "app1-asg-Japan-"
  min_size              = 1
  max_size              = 3
  desired_capacity      = 2
  vpc_zone_identifier   = [
    aws_subnet.private-ap-northeast-1a.id,
    aws_subnet.private-ap-northeast-1c.id
  ]
  health_check_type          = "ELB"
  health_check_grace_period  = 300
  force_delete               = true
  target_group_arns          = [aws_lb_target_group.app1_tg-Japan.arn]

  launch_template {
    id      = aws_launch_template.app1-J-Tele-Doctor_LT.id
    version = "$Latest"
  }

  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]

  # Instance protection for launching
  initial_lifecycle_hook {
    name                  = "instance-protection-launch"
    lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
    default_result        = "CONTINUE"
    heartbeat_timeout     = 60
    notification_metadata = "{\"key\":\"value\"}"
  }

  # Instance protection for terminating
  initial_lifecycle_hook {
    name                  = "scale-in-protection"
    lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
    default_result        = "CONTINUE"
    heartbeat_timeout     = 300
  }

  tag {
    key                 = "Name"
    value               = "app1-instance-Japan"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }
}


# Auto Scaling Policy
resource "aws_autoscaling_policy" "app1_scaling_policy-Japan" {
  name                   = "app1-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.app1_asg-Japan.name

  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 75.0
  }
}

# Enabling instance scale-in protection
resource "aws_autoscaling_attachment" "app1_asg_attachment-Japan" {
  autoscaling_group_name = aws_autoscaling_group.app1_asg-Japan.name
  lb_target_group_arn   = aws_lb_target_group.app1_tg-Japan.arn
}

