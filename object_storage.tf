resource "yandex_storage_bucket" "home_bucket" {
  bucket = var.bucket.bucket
  access_key = yandex_iam_service_account_static_access_key.st-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.st-static-key.secret_key
  max_size = var.bucket.max_size
  #default_storage_class = var.bucket.default_storage_class
  acl = "public-read"
  #acl    = var.bucket.acl
  website {
    index_document = var.name_picture
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key1.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}


resource "yandex_storage_object" "picture" {
  bucket = yandex_storage_bucket.home_bucket.bucket
  key    = var.name_picture
  source = "./img/lake.jpg"
  content_type = "image/jpeg"
  acl = "public-read"
  depends_on = [yandex_storage_bucket.home_bucket]
 

}
