locals {
  calculated_private_subnet_cidrs = [for i in range(length(var.azs)) : cidrsubnet(var.cidr, 8, i)]

  # 3 range()-> [0,1,2] -> i=0, i=1, i=2
  # 10.0.i.0/24 ->

  public_subnet_cidrs_offset     = 10
  calculated_public_subnet_cidrs = [
    for i in range(length(var.azs)) :cidrsubnet(var.cidr, 8, i+local.public_subnet_cidrs_offset)
  ]

  # (i=0) + 10 -> 10
  # (i=1) + 10 -> 11
  # ...

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  # uni-dev, uni-prod, anotherproject-dev,...
  name = join("-", [var.project, var.environment])

  cidr = var.cidr

  azs             = var.azs
  private_subnets = local.calculated_private_subnet_cidrs
  public_subnets  = local.calculated_public_subnet_cidrs

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true",
    Workspace   = terraform.workspace,
    Project     = var.project,
    Environment = var.environment,
  }

}
