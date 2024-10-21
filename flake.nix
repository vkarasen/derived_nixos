{
  description = "I am a very special flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vkarasen = {
      url = "github:vkarasen/dot_nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    vkarasen,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.default = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules =
        vkarasen.homeManagerModules 
        ++ [
          ({lib, ...}: {
            config.my.is_private = lib.mkForce false;
          })
        ];
    };

    formatter.${system} = pkgs.alejandra;
  };
}
