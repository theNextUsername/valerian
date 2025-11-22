{ pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  networking.hostName = "valerian";
  networking.firewall.allowedTCPPorts = [ 22 8000 ];
  
  environment.systemPackages = with pkgs; [
    wget
  ];
  
  users.mutableUsers = true;
  users.groups.tnu = {};
  users.groups.addi = {};
  users.users = {
    tnu = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "jupyter";
      group = "tnu";
    };
    addi ={
      isNormalUser = true;
      initialPassword = "jupyter";
      group = "addi";
      packages = with pkgs; [
        python3
        conda
        python3Packages.numpy
        python3Packages.sympy
        python3Packages.matplotlib
      ];
    };
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
      graphics = false;
    };
  };

  services.openssh.enable = true;
  
  services.jupyterhub = {
    enable = true;
    extraConfig = ''
      c.Authenticator.allow_all = True
    '';
    kernels.python3 =
    let
      env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
              ipykernel
              numpy
              sympy
              matplotlib
            ]));
    in {
      displayName = "Engineering Workbook";
      argv = [
        "${env.interpreter}"
        "-m"
        "ipykernel_launcher"
        "-f"
        "{connection_file}"
      ];
      language = "python";
      logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
      logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
    };

  };

  system.stateVersion = "25.05";
}
