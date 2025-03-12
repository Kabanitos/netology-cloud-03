output "bucket_name" {
  value = yandex_storage_bucket.home_bucket.bucket
}

output "object_url" {
  value = "https://${yandex_storage_bucket.home_bucket.bucket}.storage.yandexcloud.net/${var.name_picture}"
}