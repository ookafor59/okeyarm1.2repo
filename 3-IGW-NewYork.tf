resource "aws_internet_gateway" "igw-NewYork" {
  provider = aws.us-east-1
  vpc_id = aws_vpc.app1-NewYork.id

  tags = {
    Name    = "app1_IGW-NewYork"
    Service = "J-Tele-Doctor"
  }
}
