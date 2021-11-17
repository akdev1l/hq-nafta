terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
    uri = "qemu+ssh://akdev@virt0.hq.akdev.xyz/system"
    alias = "virt0"
}

provider "libvirt" {
    uri = "qemu+ssh://akdev@canzuk.hq.akdev.xyz/system"
    alias = "canzuk"
}

