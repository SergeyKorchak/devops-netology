resource "yandex_compute_instance" "web2" {
for_each = {for vm in var.vm_resources2: vm.vm_name => vm}
name = "netology-develop-platform-web2-${each.value.vm_name}"
resources {
    cores  = each.value.cpu
    memory  = each.value.ram
    core_fraction = each.value.core_fraction
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
    nat       = true
  }

  metadata = {
    serial-port-enable = local.serial-port-enable
    ssh-keys           = local.ssh-keys
  }
}
