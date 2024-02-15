terraform {
    backend "s3" {
        bucket = "static-website-state"
        key = "terraform/website.tfstate"
        region = "us-east-1"
    }
}
