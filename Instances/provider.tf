provider "aws" {
    region  = var.region
    shared_credentials_file = "%USERPROFILE%/.aws/creds"
    profile = "ronnie"
}