#
module "vpc" {
  source = "../../modules/vpc"
  network_name              = "jenkins"
  auto_create_subnetworks   = false
  project_id                = "nasir-434503"
  description               = "nasir"
}

