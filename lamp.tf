
resource "yandex_compute_instance_group" "group1" {
  name                = var.vm_lamp.name
  folder_id           = var.cloud_provider.folder_id
  service_account_id  = yandex_iam_service_account.vmgroup.id
  depends_on          = [yandex_resourcemanager_folder_iam_member.editor]
  instance_template {
    platform_id = var.vm_lamp.platform_id
    resources {
      memory = var.resources_lamp.memory
      cores  = var.resources_lamp.cores
      core_fraction = var.resources_lamp.core_fraction
    }
    boot_disk {
      initialize_params {
        image_id = var.lamp_image
      }
    }
    network_interface {
      network_id = yandex_vpc_network.homework.id
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
      nat = true

    }
  
    metadata = {
      foo      = "bar"
      user-data = "${file("./cloud-init.yaml")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = [var.cloud_provider.zone]
  }

  load_balancer {
    target_group_name = "target-nlb"
  }
  deploy_policy {
    max_unavailable = 2
    max_expansion   = 3
  }
  health_check {
    interval = 15
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
    http_options {
      path = "/"
      port = 80
    }
  }
}

resource "yandex_lb_network_load_balancer" "nlb" {
  name = "my-network-load-balancer"

  listener {
    name = "my-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.group1.load_balancer.0.target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}