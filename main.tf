data "template_file" "nafta_user_data" {
    template = file("${path.module}/files/windows/Autounattend.xml")
}

resource "libvirt_volume" "windows_installer" {
    provider = libvirt.canzuk
    name = "windows.iso"
    format = "iso"
    pool = "workshop.libvirt.images"
    source = "https://software-download.microsoft.com/pr/Win10_21H1_English_x64.iso?t=6efe74e5-50bb-4bb6-83e8-96e7168e16a9&e=1637035216&h=0df80fdd239f28922aa68c90a267cd31"
}
resource "libvirt_volume" "virtio_win" {
    provider = libvirt.canzuk
    source = "https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/latest-virtio/virtio-win.iso"
    name = "virtio-win.iso"
    format = "iso"
    pool = "workshop.libvirt.images"
} 
resource "libvirt_volume" "nafta_root" {
    provider = libvirt.canzuk
    name = "nafta.hq.akdev.xyz"
    format = "qcow2"
    pool = "workshop.libvirt.images"
    size = 107374182400
}

resource "libvirt_domain" "nafta_domain" {
    provider = libvirt.canzuk
    name = "nafta.hq.akdev.xyz"
    memory = 8192
    vcpu = 4
    running = false
    disk { volume_id = libvirt_volume.nafta_root.id }
    firmware = "/usr/share/OVMF/OVMF_CODE.fd"
    network_interface {
        network_name = "ovn-dmz"
        mac = "02:01:01:01:01:01"
    }
    xml {
        xslt = file("files/libvirt/nafta.xslt")
    }
}
