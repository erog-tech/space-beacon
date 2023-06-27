terraform {
  backend "remote" {
    # The name of your Terraform Cloud organization.
    organization = "erog-tech"

    # The name of the Terraform Cloud workspace to store Terraform state files in.
    workspaces {
      name = "space-beacon"
    }
  }
}