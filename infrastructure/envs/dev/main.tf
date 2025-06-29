module "network" {
  source      = "../../modules/network"
  environment = var.environment
}

module "iam" {
  source      = "../../modules/iam"
  environment = var.environment
}

module "ec2_asg" {
  source             = "../../modules/ec2_asg"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  environment        = var.environment
}
