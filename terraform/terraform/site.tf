# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "cluster-infrastructure" {
    
    count = 5
    name = "k${count.index +1}"
    vmid = "40${count.index +1}" 

    #proxmox node to create VMs
    target_node = var.proxmox_host
    
    #template name in proxmox to be cloned
    clone = var.template_name

    #basic VMs settings
    agent = 1
    os_type = "cloud-init"
    cores = 1
    sockets = 1
    cpu = "host"
    memory = 2048
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"
    

    disk {
    	slot = 0
    	# set disk size here. leave it small for testing because expanding the disk takes time.
    	size = "10G"
    	type = "scsi"
    	storage = "local-lvm"
    	iothread = 1
  	}

    network {
    	model = "virtio"
    	bridge = "vmbr0"
        }

    lifecycle {
    	ignore_changes = [
          network,
    	 ]
  	}

 ipconfig0 = "ip=192.168.10.2${count.index + 5}/24,gw=192.168.10.1"


}
