resource "aws_lb" "app1_alb-NewYork" {
    provider = aws.us-east-1
  name               = "app1-alb-NewYork"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app1-sg-LB01-NewYork.id]
  subnets            = [
    aws_subnet.public-us-east-1a.id,
    aws_subnet.public-us-east-1b.id
  ]
  enable_deletion_protection = false
#Lots of death and suffering here, make sure it's false. Prevents terraform from deleting the load balancer, prevents accidental deletions

  tags = {
    Name    = "App1LoadBalancer-NewYork"
  }
}
resource "aws_lb_listener" "https-NewYork" {
    provider = aws.us-east-1
  load_balancer_arn = aws_lb.app1_alb-NewYork.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1_tg-NewYork.arn
  }
}

output "LB-NewYork" { # NewYork dns name
  value     =  aws_lb.app1_alb-NewYork.dns_name
}


