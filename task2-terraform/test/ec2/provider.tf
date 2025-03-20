provider "aws" {
  alias="test"
  region = "eu-central-1"
  default_tags {
        tags = {
            "env" = "test"
        }
   }
}
