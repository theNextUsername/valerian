{ pkgs, config, ... }:
let
  xeus-octave = pkgs.callPackage ./xeus-octave/package.nix {
    xeus-zmq = pkgs.xeus-zmq.overrideAttrs ( rec {
      version = "3.1.1";
      src = pkgs.fetchFromGitHub {
        owner = "jupyter-xeus";
        repo = "xeus-zmq";
        rev = "${version}";
        hash = "sha256-7Af+zhz2VSXYwrQPSef/1HBmkhhYPyI1KzzhCkUJ3XY=";
      };
    });

  };
in
{

  hardware.graphics.enable = true;

  boot.loader.grub.enable = false;
  # boot.loader.grub.device = config.fileSystems."/".device;
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  networking.hostName = "valerian";
  networking.domain = "homelab.thenextusername.xyz";
  networking.firewall.allowedTCPPorts = [ 22 8000 ];
  
  environment.systemPackages = with pkgs; [
    wget
    git
    btop
  ];
  
  users.mutableUsers = true;
  users.groups.tnu = {};
  users.groups.addi = {};
  users.users = {
    root = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOzZsCPr9p5bdDz1wyhKelr+y8KtqlQDrzK63nWy1wzj tnu@aster"
      ];
    };
    tnu = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      initialPassword = "jupyter";
      group = "tnu";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBx7Q4gxioqzh7MlZ3JKHGGrOokqWkM20aHzSX2qjGnS tnu@aster"
      ];
    };
    addi ={
      isNormalUser = true;
      initialPassword = "jupyter";
      group = "addi";
    };
  };

  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 8192;
      cores = 4;
      graphics = false;
    };
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

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
  
    kernels.octave = {
      displayName = "Octave Notebook";
      argv = [
        "${pkgs.xvfb-run}/bin/xvfb-run"
        "${xeus-octave}/bin/xoctave"
        "-f"
        "{connection_file}"
      ];
      language = "octave";
      logo32 = "${xeus-octave}/share/jupyter/kernels/xoctave/logo-32x32.png";
      logo64 = "${xeus-octave}/share/jupyter/kernels/xoctave/logo-64x64.png";
    };
  };

  system.stateVersion = "25.05";
}
