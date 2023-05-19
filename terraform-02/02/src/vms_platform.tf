###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu family"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform_id"
}

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "ubuntu family"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "platform_id"
}

variable "vm_name" {
  type        = string
  default     = "netology-develop-platform"
  description = "name vm"
}

variable "vm_web_resources" {
    type = map
    default = {
      cores         = "2",
      memory        = "1",
      core_fraction = "5"
    }
}

variable "vm_db_resources" {
    type = map
    default = {
      cores         = "2",
      memory        = "2",
      core_fraction = "20"
    }
}

###ssh vars

variable "vm_ssh" {
    type = map
    default = {
      serial-port-enable = "1",
      ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIARSv/4ulUawyaYZJa4ZSh4QlqWViXjAzdSfIJkaGgtL sergey@pc"
    }
}
