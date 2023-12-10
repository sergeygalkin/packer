variables {
  iso_url_redos_733            = "https://files.red-soft.ru/redos/7.3/x86_64/iso/redos-MUROM-7.3.3-20230815.0-Everything-x86_64-DVD1.iso"
  iso_checksum_redos_733       = "357e35171e656f7742855394192c4eba"
  headless                     = true
  # CHANGEME Uncomment for build in Linux
  # accelerator                  = "kvm"
  boot_wait                    = "10s"
  boot_command                 = [
        "<esc><wait>vmlinuz ",
        "net.ifnames=0 ",
        "vga=788 ",
        "devfs=nomount ",
        "ins.text ",
        "inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/redos.ks.cfg ",
        "initrd=initrd.img",
        "<enter><wait>"
  ]
  cpus                         = 2
  memory                       = 2048
  # CHANGEME 40m is OK for MacBookPRO and may be not OK for 
  ssh_timeout                  = "40m"
  # CHANGEME For build in Linux
  # qemu_binary                  = "qemu-kvm"
  # CHANGEME For build in MAC OS
  qemu_binary                  = "qemu-system-x86_64"
  # CHANGEME Static VNC ports for handmade build, disable for CI/CD builds
  vnc_port_min                 = 5901
  vnc_port_max                 = 5901
  disk_size                    = "5G"
  ssh_username                 = "redos"
  ssh_password                 = "redos"
  output_directory             = "output"
  shutdown_timeout             = "30m"
  shutdown_command             = <<EOF
set -ex
# clear host ssh keys
sudo rm -f /etc/ssh/*host*key*
# clear logs
sudo find /var/log -maxdepth 5 -type f -exec rm -fv {} \;
# remove tmp files
sudo rm -rf /tmp/* /var/tmp/*
# truncate system files
sudo truncate -s 0 /etc/machine-id /etc/resolv.conf /var/log/audit/audit.log /var/log/wtmp \
/var/log/lastlog /var/log/btmp /var/log/cron /var/log/maillog /var/log/messages /var/log/secure \
/var/log/spooler
# remove system files
sudo rm -rf /etc/hostname /etc/machine-info /var/lib/systemd/credential.secret /var/lib/cloud /var/log/tuned \
/var/log/qemu-ga /var/log/anaconda /var/lib/systemd/random-seed
# free space with zeroes
sudo dd if=/dev/zero of=/zeroed_file bs=1M oflag=direct || sudo rm -f /zeroed_file
# clear shell history
history -c
# sync filesystem
sudo sync
# shutdown machine
sudo /sbin/shutdown -hP now
EOF
}
