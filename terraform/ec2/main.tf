data "aws_region" "current" {}

resource "aws_security_group" "sgEc2" {
  name = "security-group-ec2"
  description = "Security group for the ec2 instance"

  ingress = [
  {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "ssh enabled"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    from_port   = 18000
    to_port     = 18000
    protocol    = "tcp"
    description = "" 
    cidr_blocks = ["0.0.0.0/0"]
    }
  ]
  
}

resource "aws_instance" "ec2" {
  ami = "ami-id from amazon marketplace"
  instance_type = "t2.micro"

  security_groups = [aws_security_group.sgEc2.name]
  tags = {
    Name = "ec2-backend-static-website"
  }

}