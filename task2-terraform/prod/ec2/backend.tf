terraform {
  backend "s3" {
    bucket = "tf-infra-prod-ec2"
    key    = "terraform/state-all-prod"
    region = "eu-central-1"
  }
}
