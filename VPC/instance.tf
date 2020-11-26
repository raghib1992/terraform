resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.custom_vpc.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_key_pair" "secure_key" {
    key_name = "secure_key"
    public_key = "$file(var.PUBLIC_KEY)"
}

resource "aws_instance" "example" {
    ami = "ami-01996625fff6b8fcc"
    instance_type = "t2.micro"
    key_name = aws_key_pair.secure_key.key_name
    subnet_id = aws_subnet.public_1a.id
    vpc_security_group_ids = [ aws_security_group.allow_ssh.id ]
    tags = {
      "Name" = "example"
    }
}