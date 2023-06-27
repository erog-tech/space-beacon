terraform {
  backend "s3" {
    key    = "prod/terraform.tfstate"
    region = "eu-central-1"
  }
}