resource "yandex_storage_bucket" "bucket" {
  bucket     = "dimploma-bucket"
  access_key = yandex_iam_service_account_static_access_key.bucket-operator.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket-operator.secret_key

  anonymous_access_flags {
    read = false
    list = false
  }
}
