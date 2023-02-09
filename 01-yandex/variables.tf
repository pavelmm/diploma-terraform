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
  default = ""
}

variable "dockerhub_password" {
  default   = "*"
  sensitive = true
}

################################################################################
# GitHub
variable "github_personal_access_token" {
  default   = ""
  sensitive = true
}

variable "github_webhook_secret" {
  default = "diplomasecret"
}

variable "github_login" {
  default = ""
}
