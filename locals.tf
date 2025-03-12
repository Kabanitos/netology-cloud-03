locals {
  compute_vm_with_subnets = {
    for k, vm in var.compute_vm : k => merge(vm, {
      subnet_id = k == "public" ? yandex_vpc_subnet.public.id : yandex_vpc_subnet.private.id
    })
  }
}