locals {
  region      = "ca-central-1"
  AZs         = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
  ec2-names-1 = ["server-1", "server-2"]
  ec2-names-2 = []#["server-3", "server-4"]
  instance = { ami = "ami-0940df33750ae6e7f", type = "t2.micro"}
  public_subnets = [
    {
      name       = "public-subnet-1"
      cidr_block = "10.0.1.0/24"
      AZ         = "ca-central-1a"
    },
    {
      name       = "public-subnet-2"
      cidr_block = "10.0.2.0/24"
      AZ         = "ca-central-1b"
    },
  ]
  private_subnets = [
    { name = "private-subnet-1", cidr_block = "10.0.3.0/24" }

  ]
}

provider "aws" {
  region = local.region
}

module "infra" {
  source          = "../modules/infra"
  AZs             = local.AZs
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  instance       = local.instance
  ami             = local.ami
}
