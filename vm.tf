data "yandex_compute_image" "ubuntu" {
  family = var.family
}

resource "yandex_compute_instance" "vm" {
  for_each = local.compute_vm_with_subnets

  name        = each.value.name
  platform_id = each.value.platform_id
  zone        = var.cloud_provider.zone
  hostname    = each.value.hostname

  resources {
    cores  = each.value.cores
    memory = each.value.memory
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id

    }
  }

  scheduling_policy {
    preemptible = true
  }
    
  network_interface {
    index     = 1
    subnet_id = each.value.subnet_id
    nat       = each.value.nat


  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}


