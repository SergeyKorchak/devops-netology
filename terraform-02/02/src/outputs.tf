output "outputs" {
value = {"instance_name" = yandex_compute_instance.platform.name,
"external_ip" = yandex_compute_instance.platform.network_interface[0].nat_ip_address,
"instance_name_2" = yandex_compute_instance.platform_2.name,
"external_ip_2" = yandex_compute_instance.platform_2.network_interface[0].nat_ip_address}
}
