{
  description = "Neovim on steroid w/ flakes";

  inputs = {
    # Nixpkgs / NixOS version to use (Living on the edge)
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Useful goodies to configure Neovim with nix
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #### ------------------------- External plugins ------------------------- ####

    # Code images
    "external-plugin:nvim-silicon" = {
      url = "github:michaelrommel/nvim-silicon";
      flake = false;
    };

    # Enhanced markdown reading
    "external-plugin:markview-nvim" = {
      url = "github:OXY2DEV/markview.nvim";
      flake = false;
    };

    "external-plugin:blink-compat" = {
      url = "github:saghen/blink.compat";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
      ...
    }@inputs:
    with builtins;
    let
      system = "x86_64-linux";

      # Modules used to configure neovim
      module = {
        imports = [
          ./config.nix
          ./plugins
          ./modules
        ];
      };

      # Parse the inputs taking only the plugins needed to extend neovim capabilities
      inputsMatching =
        prefix:
        pkgs.lib.mapAttrs' (prefixedName: value: {
          name = substring (stringLength "${prefix}:") (stringLength prefixedName) prefixedName;
          inherit value;
        }) (pkgs.lib.filterAttrs (name: _: (match "${prefix}:.*" name) != null) inputs);

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (_final: prev: {
            vimPlugins =
              prev.vimPlugins
              // (pkgs.lib.mapAttrs (
                pname: src:
                prev.vimPlugins."${pname}".overrideAttrs (_old: {
                  version = src.shortRev;
                  inherit src;
                })
              ) (inputsMatching "plugin"))
              // (pkgs.lib.mapAttrs (
                pname: src:
                prev.vimUtils.buildVimPlugin {
                  inherit pname src;
                  version = src.shortRev;
                }
              ) (inputsMatching "external-plugin"));
          })
        ];
      };

      nixvim' = nixvim.legacyPackages."${system}";
      nvim = nixvim'.makeNixvimWithModule { inherit module pkgs; };
    in
    {
      devShells."${system}".default = pkgs.mkShell { packages = [ nvim ]; };
      packages."${system}" = {
        inherit nvim;
        inherit (pkgs.vimPlugins) nvim-treesitter;
        default = nvim;
      };
    };
}
