resource "yandex_compute_disk" "empty-disk" {
count = 3
  name       = "empty-disk-${count.index}"
  type       = "network-hdd"
  zone       = "ru-central1-a"
  size       = 64
}

resource "yandex_compute_instance" "web_disk" {
  name = "vm"
  resources {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat = true
  }
  metadata = {
    serial-port-enable = local.serial-port-enable
    ssh-keys = local.ssh-keys
  }
}
