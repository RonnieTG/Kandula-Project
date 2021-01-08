provider "aws" {
    region  = var.region
    version = "~> 2.0"
    #shared_credentials_file = "%USERPROFILE%/.aws/credentials"
    profile = "ronnie"
}