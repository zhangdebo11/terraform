terraform {
  backend "gcs" {
    bucket = "smartcart-stagingization-tfstate"
    prefix = "staging"
  }
}
