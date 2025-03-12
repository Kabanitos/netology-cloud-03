data "yandex_compute_image" "ubuntu-nat" {
  family = var.image_nat
}

resource "yandex_compute_instance" "nat_instance" {
  name        = var.compute_nat.name
  platform_id = var.compute_nat.platform_id
  zone        = var.cloud_provider.zone

  resources {
    cores  = var.resources_nat.cores
    memory = var.resources_nat.memory
    core_fraction = var.resources_nat.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-nat.id

    }
  }

  scheduling_policy {
    preemptible = true
  }
    
  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.public.id
    nat       = var.network_nat.nat
    ip_address = var.network_nat.ip_address


  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

