module "vpc" {
  source   = "./modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "ecr" {
  source             = "./modules/ecr"
  ecr_wordpress_name = var.ecr_wordpress_name
}

module "task_definition" {
  source            = "./modules/task_definition"
  ecr_uri_wordpress = module.ecr.ecr_uri_wordpress
  rds_endpoint      = module.rds.db_endpoint
  db_username       = var.db_username
  db_password       = var.db_password
  db_name           = var.db_name
}

module "ecs" {
  source              = "./modules/ecs"
  task_definition_arn = module.task_definition.task_definition_arn
  public_subnets      = module.vpc.public_subnets
  security_group_id   = module.sg.security_group_id
}

module "rds" {
  source                    = "./modules/rds"
  private_subnets           = module.vpc.private_subnets
  security_group_private_id = module.sg.security_group_private_id
  db_username               = var.db_username
  db_password               = var.db_password
  db_name                   = var.db_name
}
