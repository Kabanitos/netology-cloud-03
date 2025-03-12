resource "yandex_vpc_network" "homework" {
  name = "homework"
}

resource "yandex_vpc_subnet" "public" {
  name = var.subnet_public.name
  v4_cidr_blocks = [var.subnet_public.v4_cidr_blocks]
  zone           = var.cloud_provider.zone
  network_id     = yandex_vpc_network.homework.id
  description = var.subnet_public.description
}

resource "yandex_vpc_subnet" "private" {
  name = var.subnet_private.name
  v4_cidr_blocks = [var.subnet_private.v4_cidr_blocks]
  zone           = var.cloud_provider.zone
  network_id     = yandex_vpc_network.homework.id
  description = var.subnet_private.description
  route_table_id = yandex_vpc_route_table.table1.id
}



resource "yandex_vpc_route_table" "table1" {
  network_id = yandex_vpc_network.homework.id 

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.network_nat.ip_address
  }
}