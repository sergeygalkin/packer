source "qemu" "redos-7" {
  # CHANGEME Uncomment for build in Linux
  # accelerator               = var.accelerator
  boot_wait                 = var.boot_wait
  boot_command              = var.boot_command
  cpus                      = var.cpus
  disk_image                = false
  disk_size                 = var.disk_size
  disk_interface            = "virtio-scsi"
  disk_cache                = "unsafe"
  disk_discard              = "unmap"
  disk_detect_zeroes        = "unmap"
  disk_compression          = true
  format                    = "qcow2"
  net_device                = "virtio-net"
  headless                  = var.headless
  memory                    = var.memory
  qemu_binary               = var.qemu_binary
  shutdown_command          = var.shutdown_command
  shutdown_timeout          = var.shutdown_timeout
  ssh_timeout               = var.ssh_timeout
  ssh_username              = var.ssh_username
  ssh_password              = var.ssh_password
  vnc_port_min              = var.vnc_port_min
  vnc_port_max              = var.vnc_port_max
  ssh_clear_authorized_keys = false
  qemuargs                  = []
  output_directory          = var.output_directory
  vm_name                   = "${source.name}.qcow2"
  http_directory            = "ks"
}

build {
  source "qemu.redos-7" {
    name         = "redos-7.3.3"
    iso_checksum = var.iso_checksum_redos_733
    iso_url      = var.iso_url_redos_733
  }

  provisioner "shell" {
    execute_command = "sudo -S env {{ .Vars }} {{ .Path }}"
    script          = "scripts/provision.sh"
    pause_before    = "10s"
  }
}
