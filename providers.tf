terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.138.0"
    }
  }
}

provider "yandex" {
  cloud_id  = var.cloud_provider.cloud_id
  folder_id = var.cloud_provider.folder_id
  zone      = var.cloud_provider.zone
  service_account_key_file = file("~/authorized_key.json")
}
