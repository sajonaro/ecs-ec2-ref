output "vpc_id" {
  value = aws_default_vpc.default_vpc.id
  
}

output "vpc_az_ids" {
   value = tolist([aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id])
  
}