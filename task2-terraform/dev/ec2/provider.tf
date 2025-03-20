provider "aws" {
  alias="dev"
  region = "eu-central-1"
  default_tags {
        tags = {
            "env" = "dev"
        }
   }
}
