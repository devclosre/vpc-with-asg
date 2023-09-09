terraform {
  backend "s3" {
    bucket = "taskone-terraform-backend"
    key    = "terraform.tfstate"
    region = "ap-southeast-2"
    dynamodb_table = "taskone-terraform-statelock"
  }
}
