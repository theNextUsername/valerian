{ ... }: {

  services.cloud-init.network.enable = true;

  virtualisation.diskSize = 8 * 1024;
  virtualisation.qemu.guestAgent.enable = true;

  proxmox = {
    cores = 4;
    memory = 8192;
    name = "valerian";
    net0 = "virtio=00:00:00:00:00:00,bridge=vmbr1,firewall=1";
    agent = true;
    cloudInit = true;
    defaultStorage = "vm-pool";
  };
   
}
