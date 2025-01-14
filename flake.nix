{
  description = "Development Shell For this repository";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    {
      nixpkgs,
      ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # TODO: i want to compile my keyboard using nix as a build system
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs; [
          keymapviz
          qmk
        ];
        shellHook = ''
          echo 'Welcome to my keyboard development.'
          keymapviz -k crkbd keymap.c
        '';
      };
    };
}