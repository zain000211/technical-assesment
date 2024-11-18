terraform {
    required_version = ">=1.3.3"
      backend "s3" {
        bucket = "kc-state-terraform"
        key    = "kc/terraform.tfstate"
        region = "me-central-1"
    }
}

provider "aws" {
    alias = "primary"
    region = "me-central-1"


}

provider "aws" {
    alias = "secondary"
    region = "us-east-1"
}
