provider "aws" {
  region     = "ca-central-1"

}

data "aws_security_group" "selected" {
  id = "sg-086a16f761d3e8365"
}

resource "aws_instance" "web" {
  ami           = "ami-01c7ecac079939e18"
  instance_type = "t2.micro"
  vpc_security_group_ids = [data.aws_security_group.selected.id]
  key_name = aws_key_pair.deployer.key_name

  tags = {
    Name = "test-terraform"
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("/home/aebouel/.ssh/id_rsa.pub")
}