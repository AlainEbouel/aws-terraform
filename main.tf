provider "aws" {
  region     = "ca-central-1"
#   access_key = "AKIA4TOAE57I6MX7BX3D"
#   secret_key = "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"
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

# data "aws_key_pair" "key_pair" {
#   key_name           = "keypair1_canada_central"
#   include_public_key = true

  
# }

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("/home/aebouel/.ssh/id_rsa.pub") #"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}
