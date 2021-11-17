resource "libvirt_volume" "fedora_installer" {
    provider = libvirt.canzuk
    name = "fedora.iso"
    format = "iso"
    pool = "workshop.libvirt.images"
    source = "https://download.fedoraproject.org/pub/fedora/linux/releases/35/Kinoite/x86_64/iso/Fedora-Kinoite-ostree-x86_64-35-1.2.iso"
}
resource "libvirt_volume" "f35_kernel" {
    provider = libvirt.canzuk
    source = "http://fedora.mirror.iweb.com/linux//development/35/Everything/x86_64/os/isolinux/vmlinuz"
    name = "f35-vmlinuz"
    format = "raw"
    pool = "workshop.libvirt.images"
}
resource "libvirt_volume" "f35_initrd" {
    provider = libvirt.canzuk
    source = "http://fedora.mirror.iweb.com/linux//development/35/Everything/x86_64/os/isolinux/initrd.img"
    name = "f35-initrd.img"
    pool = "workshop.libvirt.images"
}

resource "libvirt_volume" "otan_root" {
    provider = libvirt.canzuk
    name = "nafta.hq.akdev.xyz"
    format = "qcow2"
    pool = "workshop.libvirt.images"
    size = 107374182400
}

resource "libvirt_domain" "otan_domain" {
    provider = libvirt.canzuk
    name = "otan.hq.akdev.xyz"
    memory = 8192
    vcpu = 4
    disk { volume_id = libvirt_volume.otan_root.id }
    firmware = "/usr/share/OVMF/OVMF_CODE.fd"
    running = false
    kernel  = libvirt_volume.f35_kernel.id
    initrd = libvirt_volume.f35_initrd.id
    cmdline = [
        {
            "inst.stage2" = "hd:LABEL=Fedora-Knt-ostree-x86_64-35",
            "_" = "inst.text"
        }
    ]
    network_interface {
        network_name = "ovn-dmz"
        mac = "02:02:01:01:01:01"
    }
    xml {
        xslt = file("files/libvirt/otan.xslt")
    }
}
