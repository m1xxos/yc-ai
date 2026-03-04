terraform {
  backend "s3" {
    endpoint                    = "https://storage.yandexcloud.net"
    region                      = "ru-central1"
    bucket                      = var.bucket
    key                         = "yc-ai.tfstate"
    access_key                  = var.access_key
    secret_key                  = var.secret_key
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}


terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.190.0"
    }
  }
  required_version = ">= 0.13"
}


provider "yandex" {
  zone = "ru-central1-b"
}
