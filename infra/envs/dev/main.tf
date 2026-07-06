module "network" {
  source = "../../modules/network"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  availability_zone   = "ap-south-1a"
}

module "rds" {
  source = "../../modules/rds"

  vpc_id            = module.network.vpc_id
  private_subnet_id = module.network.private_subnet_id

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  instance_class      = var.db_instance_class
  backup_retention    = var.backup_retention
  deletion_protection = var.deletion_protection
}

module "ecs" {
  source = "../../modules/ecs"

  vpc_id             = module.network.vpc_id
  public_subnet_id   = module.network.public_subnet_id
  public_subnet_id_2 = module.network.public_subnet_id

  cpu    = var.ecs_cpu
  memory = var.ecs_memory
}