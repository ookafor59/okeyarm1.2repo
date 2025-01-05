#These are   for  public

resource "aws_subnet" "public-us-east-1a" {
  provider = aws.us-east-1
  vpc_id                  = aws_vpc.app1-NewYork.id
  cidr_block              = "10.151.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-us-east-1a"
    Service = "J-Tele-Doctor"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  provider = aws.us-east-1
  vpc_id                  = aws_vpc.app1-NewYork.id
  cidr_block              = "10.151.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name    = "public-us-east-1b"
    Service = "J-Tele-Doctor"
  }
}

#these are for private
resource "aws_subnet" "private-us-east-1a" {
  provider = aws.us-east-1
  vpc_id            = aws_vpc.app1-NewYork.id
  cidr_block        = "10.151.11.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name    = "private-us-east-1a"
    Service = "J-Tele-Doctor"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  provider = aws.us-east-1
  vpc_id            = aws_vpc.app1-NewYork.id
  cidr_block        = "10.151.12.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name    = "private-us-east-1b"
    Service = "J-Tele-Doctor"
  }
}
