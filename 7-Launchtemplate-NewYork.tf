data "aws_ami" "latest-amazon-linux-image-NewYork" {
    provider = aws.us-east-1
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["amzn2-ami-kernel-*-x86_64-gp2"]
    }
    filter {
        name = "virtualization-type"
        values = ["hvm"]
    }
}








resource "aws_launch_template" "app1-J-Tele-Doctor_LT-NewYork" { # Each EC2 instance hosts the J-Tele-Doctor application and are syslog agents
    provider = aws.us-east-1  
  name_prefix   = "NewYork-app1-J-Tele-Doctor_LT"
  image_id      = data.aws_ami.latest-amazon-linux-image-NewYork.id  
  instance_type = "t2.micro"

  key_name = aws_key_pair.MyLinuxBox2-NewYork.key_name

  vpc_security_group_ids = [aws_security_group.app1-sg1-servers-NewYork.id]

  user_data = base64encode(data.template_file.user_data.rendered)

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "NewYork-app1_LT"
      Service = "J-Tele-Doctor"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

