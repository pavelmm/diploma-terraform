// Create SA
resource "yandex_iam_service_account" "bucket-operator" {
  folder_id = var.yandex_folder_id
  name      = "bucket-operator"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "viewer" {
  folder_id = var.yandex_folder_id
  role      = "viewer"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-operator.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "editor" {
  folder_id = var.yandex_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-operator.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "bucket-operator" {
  service_account_id = yandex_iam_service_account.bucket-operator.id
  description        = "static access key for object storage"
}