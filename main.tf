terraform {
  backend "s3" {
    bucket = "space-beacon-erog"
    key    = "prod/terraform.tfstate"
    region = "eu-central-1"
  }
}