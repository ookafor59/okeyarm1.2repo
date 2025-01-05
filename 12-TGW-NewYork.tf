
resource "aws_ec2_transit_gateway" "NewYork-TGW1" {
    provider = aws.us-east-1
  tags = {
    Name: "NewYork-TGW1"
  }
}
output "TGW-Peer-attach-ID-NewYork" {
  value       = aws_ec2_transit_gateway.NewYork-TGW1.id
  description = "TGW ID"
}


resource "aws_ec2_transit_gateway_vpc_attachment" "Private-VPC-NewYork-TG-attach" {
    provider = aws.us-east-1
  subnet_ids         = [aws_subnet.private-us-east-1a.id, aws_subnet.private-us-east-1b.id]
  transit_gateway_id = aws_ec2_transit_gateway.NewYork-TGW1.id
  vpc_id             = aws_vpc.app1-NewYork.id
  transit_gateway_default_route_table_association = false #or  by default associate to default NewYork-TGW-Route-table
  transit_gateway_default_route_table_propagation = false #or  by default propagate to default NewYork-TGW-Route-table
}





resource "aws_ec2_transit_gateway_route_table" "NewYork-TG-Route-Table" { #TGW route table NewYork
    provider = aws.us-east-1 
  transit_gateway_id = aws_ec2_transit_gateway.NewYork-TGW1.id 
}

resource "aws_ec2_transit_gateway_route_table_association" "NewYork-TGW1_Association" { #Associates NewYork-VPC-TGW-attach to NewYork-TGW-Route-Table
    provider = aws.us-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-NewYork-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.NewYork-TG-Route-Table.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "NewYork-TGW1_Propagation" { #Propagates NewYork-VPC-TGW-attach to NewYork-TGW-Route-Table
    provider = aws.us-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.Private-VPC-NewYork-TG-attach.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.NewYork-TG-Route-Table.id
}




resource "aws_ec2_transit_gateway_peering_attachment_accepter" "NewYork_Japan_Peer_Accepter" { #accept peer
  provider = aws.us-east-1
  transit_gateway_attachment_id = aws_ec2_transit_gateway_peering_attachment.Japan_NewYork_Peer.id
  tags = {
    Name = "NewYork-Japan-Peer-Accepter"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "NewYork-to-Japan-TGW1_Peer_Association" { #Associates NewYork-Japan-TGW-Peer to NewYork-TGW-Route-Table
    provider = aws.us-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment_accepter.NewYork_Japan_Peer_Accepter.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.NewYork-TG-Route-Table.id
  replace_existing_association = true #removes default TGW-Route-Table-Association so you can Associate with the one specified in your code
}

resource "aws_ec2_transit_gateway_route" "NewYork_to_Japan_Route" { #Route on TG NewYork -> to -> Japan
    provider = aws.us-east-1
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.NewYork-TG-Route-Table.id
  destination_cidr_block         = "10.150.0.0/16"  # CIDR block of the VPC in sa-east-1
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_peering_attachment.Japan_NewYork_Peer.id
}


