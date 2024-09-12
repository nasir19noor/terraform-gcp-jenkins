terraform {
  backend "gcs" {
    bucket = "terraform-state-nasir"
    prefix = "jenkins/gke"
  }
}