################################################################################
# Yandex IDs
variable "yandex_cloud_id" {
  default = "b1ggmrv6sescdjd1dbdr"
}

variable "yandex_folder_id" {
  default = "b1gntvp7bk1cakoqremf"
}

variable "yandex_compute_default_zone" {
  default = "ru-central1-a"
}

################################################################################
# DockerHub
variable "dockerhub_login" {
  default = "romb32"
}

variable "dockerhub_password" {
  default   = "2323Ella2323"
  sensitive = true
}

################################################################################
# GitHub
variable "github_personal_access_token" {
  default   = "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"
  sensitive = true
}

variable "github_webhook_secret" {
  default = "diplomasecret"
}

variable "github_login" {
  default = "pavelmm"
}
