resource "yandex_kms_symmetric_key" "key1" {
  name              = "test-key"
  description       = "key-for-bucket"
  default_algorithm = "AES_256"
  rotation_period   = "720h" // equal to 1 year
}