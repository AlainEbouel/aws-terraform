# resource "aws_instance" "ec2_instances-1" {
#   count = length(var.ec2-names-1)

#   ami                         = var.ami
#   instance_type               = "t2.micro"
#   vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
#   key_name                    = aws_key_pair.demo-keypair.id
#   subnet_id                   = aws_subnet.public-subnet[0].id
#   associate_public_ip_address = true

#   tags = {
#     Name = var.ec2-names-1[count.index]
#   }
#   user_data = file("../modules/infra/instance-launch.sh")
#   user_data_replace_on_change = true
#   # iam_instance_profile = data.aws_iam_instance_profile.iprofile.arn
# }

# resource "aws_instance" "ec2_instances-2" {
#   count = length(var.ec2-names-2)

#   ami                         = var.ami
#   instance_type               = "t2.micro"
#   vpc_security_group_ids      = [aws_security_group.ec2-sg.id]
#   key_name                    = aws_key_pair.demo-keypair.id
#   subnet_id                   = aws_subnet.public-subnet[1].id
#   associate_public_ip_address = true

#   tags = {
#     Name = var.ec2-names-2[count.index]
#   }
#   # iam_instance_profile = data.aws_iam_instance_profile.iprofile.arn
# }
resource "aws_launch_template" "demo-launch-template" {
  name = "demo-launch-template"

  # iam_instance_profile {
  #   name = "test"
  # }

  image_id = var.instance.ami
  instance_type = var.instance.type
  key_name = aws_key_pair.demo-keypair.id
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "demo"
    }
  }

  user_data = file("../modules/infra/instance-launch.sh")
  lifecycle {
    ignore_changes = [ user_data ]
  }
}

resource "aws_security_group" "alb-sg" {
  name        = "public-sg"
  description = "Allow public inbound traffic"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description = "allow https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow http"
    from_port   = 80
    to_port     = 80
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
    Name = "alb-sg"
  }
}

resource "aws_security_group" "ec2-sg" {
  name        = "ec2-sg"
  description = "Allow public inbound traffic from alb"
  vpc_id      = aws_vpc.demo_vpc.id

  ingress {
    description     = "allow http from alb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    description = "allow ssh from personal ip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my-Home-IP]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg"
  }
}

data "aws_ssm_parameter" "keypair-public-key" {
  name  = "keypair-public-key"
}

resource "aws_key_pair" "demo-keypair" {
  key_name   = "demo-key-pair"
  public_key = data.aws_ssm_parameter.keypair-public-key.value
}

resource "aws_lb_target_group" "demo-target_group" {
  name     = "demo-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo_vpc.id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    unhealthy_threshold = 5
    interval            = 10
    matcher             = 200
    path                = "/"
    timeout             = 8

  }
}

# resource "aws_lb_target_group_attachment" "ec2_instances-1-TG-attachment-1" {
#   count = length(concat(var.ec2-names-1, var.ec2-names-2))

#   target_group_arn = aws_lb_target_group.demo-target_group.arn
#   target_id        = concat(aws_instance.ec2_instances-1, aws_instance.ec2_instances-1)[count.index].id
#   port             = 80
# }
resource "aws_autoscaling_attachment" "demo-elb-ASG-attachment" {
  autoscaling_group_name = aws_autoscaling_group.demo-ASG.id
  # elb                    = aws_lb.demo-alb.arn
  lb_target_group_arn    = aws_lb_target_group.demo-target_group.id
}

resource "aws_autoscaling_group" "demo-ASG" {
  vpc_zone_identifier = [for sub in aws_subnet.public-subnet: sub.id]
  desired_capacity   = 2             
  max_size           = 3
  min_size           = 1
  health_check_type = "ELB"
 
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.demo-launch-template.id
      }
    }
  }
}


resource "aws_autoscaling_attachment" "demo-TG-ASG-attachment" {
  autoscaling_group_name = aws_autoscaling_group.demo-ASG.id
  lb_target_group_arn    = aws_lb_target_group.demo-target_group.arn
}

resource "aws_lb" "demo-alb" {
  name               = "demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [for subnet in aws_subnet.public-subnet : subnet.id]

}

resource "aws_lb_listener" "demo-alb-listener" {
  load_balancer_arn = aws_lb.demo-alb.arn
	port = 80
	protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.demo-target_group.arn
    type             = "forward"
  }
}