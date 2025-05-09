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
    qmk-git = {
      url = "github:qmk/qmk_firmware/0.28.2";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      qmk-git,
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
      packages."${system}".default = pkgs.stdenv.mkDerivation {
        name = "corne";
        # src = ./.;
        srcs = [
          ( ./. )
          ( pkgs.fetchFromGitHub {
            name = "qmk_firmware";
            owner = "qmk";
            repo = "qmk_firmware";
            tag = "0.28.2";
            hash = "sha256-mNySUNgB2rmY+TwSRIFAWj+W77dM27dkiGy0eznawkw=";
          } )
        ];
        sourceRoot = ".";
        buildPhase = ''
          pwd
          ls -lah
          # cp -r ${qmk-git} ./qmk_firmware
          ${pkgs.lib.getExe pkgs.tree} . | head -n 20
          ls -lah ./qmk_firmware
          mkdir -p testttt
          # mkdir -p ./qmk_firmware/testttt
          # mkdir -p ./qmk_firmware/keyboards/testttt

          # cp -r ${./.} ./qmk_firmware/keyboards/crkbd/keymaps/osbm-config
          # ${pkgs.lib.getExe pkgs.tree} . | head -n 20

          mkdir -p $out
        '';
        buildInputs = [
          pkgs.qmk
        ];
        # buildPhase = ''
        #   qmk setup
        # '';
        

      };
    };
}
