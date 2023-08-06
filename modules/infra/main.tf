

# # data "aws_security_group" "selected" {
# #   id = "sg-086a16f761d3e8365"
# # }
# locals {

# }

# resource "aws_instance" "web" {
#   count = length(local.ec2-names)
#   /*amazon linux */
#   ami= "ami-09988af04120b3591"
#   instance_type = "t2.micro"
#   # vpc_security_group_ids = [resource.aws_security_group.security_group.id]
#   # key_name = data.aws_key_pair.keyp.id

#   tags = {
#     Name = "server-${count.index}"
#   }
#   # iam_instance_profile = data.aws_iam_instance_profile.iprofile.arn
# }
# data "aws_vpc" "main" {
#   id = "vpc-03abf57ec183b9b60"
# }

# # resource "aws_key_pair" "deployer" {
# #   key_name   = "WhizKey2"
# #   public_key = file("/home/aebouel/.ssh/id_rsa.pub")
# # }
# # data "aws_key_pair" "keyp"{
# #   key_name = "whis-kye-2.pem"
# # }  

# # resource "aws_security_group" "security_group" {
# #   name        = "MyEC2Server_SG"
# #   description = " Security Group to allow traffic to EC2"
# #   vpc_id      = data.aws_vpc.main.id

# #   ingress {
# #     # description      = "TLS from VPC"
# #     from_port        = 22
# #     to_port          = 22
# #     protocol         = "tcp"
# #     cidr_blocks      = [data.aws_vpc.main.cidr_block]
# #   }

# #   egress {
# #     from_port        = 0
# #     to_port          = 0
# #     protocol         = "-1"
# #     cidr_blocks      = ["0.0.0.0/0"]
# #     ipv6_cidr_blocks = ["::/0"]
# #   }

# #   tags = {
# #     Name = "allow_tls"
# #   }
# # }

# # data "aws_iam_instance_profile" "iprofile" {
# #   name = "task124_ec2_134048.51257983"
# # }