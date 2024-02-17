terraform {
    backend "s3" {
        bucket = "static-website-state"
        key = "terraform/rds.tfstate"
        region = "us-east-1"
    }
}
