resource "aws_vpc" "app1-NewYork" {
  provider = aws.us-east-1
  cidr_block = "10.151.0.0/16"

  tags = {
    Name = "app1"
    Service = "J-Tele-Doctor"
  }
}