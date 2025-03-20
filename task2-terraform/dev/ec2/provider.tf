provider "aws" {
  alias="prod"
  region = "eu-central-1"
  default_tags {
        tags = {
            "env" = "prod"
        }
   }
}
