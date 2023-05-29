Для выполнения задания вам потребуется создать два файла: count-vm.tf и for_each-vm.tf. Давайте начнем с count-vm.tf:

terraform
Copy code
# Определение провайдера Yandex.Cloud
provider "yandex" {
  # Укажите необходимые данные для доступа к Yandex.Cloud
}

# Определение ресурса диска
resource "yandex_compute_disk" "disk_vm" {
  count       = 3
  name        = "disk${count.index}"
  size        = 1
  description = "Virtual disk"

  # Укажите остальные необходимые параметры для создания диска
}

# Определение ресурса виртуальной машины web
resource "yandex_compute_instance" "web" {
  count         = 2
  name          = "web-${count.index + 1}"
  zone          = "your-zone" # Укажите необходимую зону
  platform_id   = "standard-v2"
  cores         = 1
  memory        = 2
  boot_disk {
    initialize_params {
      # Укажите необходимые параметры для диска ОС
    }
  }

  network_interface {
    subnet_id = "your-subnet-id" # Укажите необходимый subnet_id
  }

  metadata = {
    ssh-keys = "your-public-ssh-key" # Укажите публичный SSH-ключ
  }
}

# Определение ресурса группы безопасности
resource "yandex_vpc_network_security_group" "security_group" {
  name        = "security-group"
  description = "Security group for VMs"

  # Укажите необходимые параметры для группы безопасности
}

# Привязка группы безопасности к виртуальным машинам
resource "yandex_compute_instance_network_interface_security_group" "web" {
  for_each        = yandex_compute_instance.web
  network_id      = each.value.network_interface[0].network_id
  security_group_id = yandex_vpc_network_security_group.security_group.id
}
Не забудьте заменить комментарии # Укажите необходимые данные для доступа к Yandex.Cloud, # Укажите остальные необходимые параметры и your-zone, your-subnet-id и your-public-ssh-key на соответствующие значения, такие как токен доступа Yandex.Cloud, параметры конфигурации виртуальных машин и другие необходимые данные.

Теперь создадим файл for_each-vm.tf:

terraform
Copy code
# Определение провайдера Yandex.Cloud
provider "yandex" {
  # Укажите необходимые данные для доступа к Yandex.Cloud
}

# Определение переменной с конфигурацией виртуальных машин
variable "vms" {
  type = list(object({
    vm_name = string
    cpu     = number
    ram     = number
    disk    = number
  }))
  default = [
    {
      vm_name = "main"
      cpu     = 2
      ram     = 4
      disk    = 