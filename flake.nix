{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  { 
    nixosConfigurations.valerian = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./hardware-proxmox.nix
      ];
    };
    
    devShells.${system} = {
      default = pkgs.mkShellNoCC {
        QEMU_NET_OPTS = "hostfwd=tcp::2221-:22,hostfwd=tcp::8081-:8081,hostfwd=tcp::8000-:8000";
      };
    };
  };
}
