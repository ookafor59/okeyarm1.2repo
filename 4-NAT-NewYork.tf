resource "aws_eip" "nat-NewYork" { #elastic IP
provider = aws.us-east-1
  domain = "vpc"

  tags = {
    Name = "nat-NewYork"
  }
}

resource "aws_nat_gateway" "nat-NewYork" {
  provider = aws.us-east-1
  allocation_id = aws_eip.nat-NewYork.id #.nat references aws_eip.nat object
  subnet_id     = aws_subnet.public-us-east-1a.id 

  tags = {
    Name = "nat-NewYork"
  }

  depends_on = [aws_internet_gateway.igw-NewYork] # ensures terraform creates IGW before creating this resource(NGW). NGW depend on IGW
}
