# RedOS

Tested on Linux and MacOS on M1

After build you can find qcow2 image in output dir.

Requirements:

- qemu. `brew install qemu` for MacOS

Peculiarities:

- Not universal. Now is working on MacOS with M1, for Linux please `grep -r CHANGEME *` and edit.
- Despite the file image size 1.3G the real disk size is 5GB. So minimal disk size for your VM in the Openstack is 5GB.
- The root password is 'TheSw0rdFish' and stored as clear text in kickstart script. Yes, it's not very secure :)
- VNC port is static. It's good for manual build, but it's not good for CI/CD. Please comment vnc_port_min and vnc_port_max in [redos-7.pkr.hcl](redos-7.pkr.hcl) for run in your CI/CD.
- Do not install cloud-init inside [redos.ks.cfg](redos.ks.cfg). This will break the build.
- Check [redos.ks.cfg](redos.ks.cfg) and [scripts/provision.sh](scripts/provision.sh). We are many soft installation in this files. Comment or add something if you need.
