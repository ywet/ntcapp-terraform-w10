terraform {
  backend "s3" {
    bucket = "wk7-yw-bucket"
    key = "week10/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = false
  }
}