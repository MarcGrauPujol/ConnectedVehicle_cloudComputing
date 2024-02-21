terraform {
    backend "s3" {
        bucket = "static-website-state"
        key = "terraform/sns.tfstate"
        region = "us-east-1"
    }
}
