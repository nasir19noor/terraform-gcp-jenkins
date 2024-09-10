terraform {
  backend "gcs" {
    bucket = "terraform-state-nasir"
    prefix = "gcp/jenkins/vpc"
  }
}