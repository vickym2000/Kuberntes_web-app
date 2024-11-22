provider "aws"{
    region ="us-east-1"
}
 
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
 
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2_key"
  public_key = tls_private_key.rsa.public_key_openssh
}
 
resource "local_file" "ec2pri" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ec2pri"
}
 
resource "aws_instance" "parent"{
    ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    key_name = aws_key_pair.ec2_key.key_name
    tags = {
    Name = "masternode"
    }
 }
 
resource "aws_instance" "child" {
     ami = "ami-0866a3c8686eaeeba"
    instance_type = "t2.micro"
    key_name = aws_key_pair.ec2_key.key_name
    tags = {
    Name = "workernode"
    }
}
