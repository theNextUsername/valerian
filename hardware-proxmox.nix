{ ... }: {
  services.cloud-init.network.enable = true;

  virtualisation.diskSize = 8 * 1024;
  # virtualisation.qemu.guestAgent.enable = true;

  proxmox = {
    qemuConf = {
      cores = 4;
      memory = 8192;
      name = "valerian";
      agent = true;
      net0 = "virtio=00:00:00:00:00:00,bridge=vmbr1,firewall=1";
    };
    cloudInit = {
      enable = true;
      defaultStorage = "vm-pool";
    };
  };
   
}
