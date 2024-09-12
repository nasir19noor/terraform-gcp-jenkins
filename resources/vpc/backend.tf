terraform {
  backend "gcs" {
    bucket = "terraform-state-nasir"
    prefix = "jenkins-2/vpc"
  }
}