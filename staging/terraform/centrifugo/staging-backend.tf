terraform {
  backend "gcs" {
    bucket = "staging-standard-cluster"
    prefix = "staging-tfstate-centrifugo-cluster"
  }
}