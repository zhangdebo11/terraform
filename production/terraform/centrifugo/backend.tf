terraform {
  backend "gcs" {
    bucket = "production-standard-cluster"
    prefix = "production-tfstate-centrifugo-cluster"
  }
}
