terraform {
  backend "s3" {
    bucket       = "grim-82-devops-platform-tfstate"
    key          = "labs/01-vpc/terraform.tfstate"
    region       = "eu-west-1"
    profile      = "devops-platform"
    encrypt      = true
    use_lockfile = true
  }
}
