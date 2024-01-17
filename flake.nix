{
  description = "Neovim on steroid w/ flakes";

  inputs = {
    # Nixpkgs / NixOS version to use (Living on the edge)
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Neovim bleeding edge version
    neovim-flake = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Useful goodies to configure Neovim with nix
    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #### ------------------------- PLUGINS ------------------------- ####
    "plugin:plenary-nvim" = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # Adds file type icons to neovim
    "plugin:nvim-web-devicons" = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    # UI Component Library for Neovim
    "plugin:nui-nvim" = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    # Signature helper
    "plugin:neodev" = {
      url = "github:folke/neodev.nvim";
      flake = false;
    };

    ### ------------------------- Colorschemes ------------------------- ###
    "plugin:nightfox" = {
      url = "github:EdenEast/nightfox.nvim";
      flake = false;
    };

    "plugin:adwaita-nvim" = {
      url = "github:Mofiqul/adwaita.nvim";
      flake = false;
    };

    "external-plugin:vim-moonfly-colors" = {
      url = "github:bluz71/vim-moonfly-colors";
      flake = false;
    };

		"external-plugin:citruszest-nvim" = {
      url = "github:zootedb0t/citruszest.nvim";
      flake = false;
		};

    # Statusline
    "external-plugin:staline-nvim" = {
      url = "github:tamton-aquib/staline.nvim";
      flake = false;
    };

  };

  outputs = {
    self,
    nixpkgs,
    nixvim,
    neovim-flake,
    ...
  } @ inputs:
    with builtins; let
      system = "x86_64-linux";

      # Modules used to configure neovim
      module = {
        imports = [
          ./config.nix
          ./plugins
          ./modules
        ];

        # Bleeding edge neovim version
        package = neovim-flake.packages."${system}".neovim;
      };

      # Parse the inputs taking only the plugins needed to extend neovim capabilities
      inputsMatching = prefix:
        pkgs.lib.mapAttrs'
        (prefixedName: value: {
          name = substring (stringLength "${prefix}:") (stringLength prefixedName) prefixedName;
          inherit value;
        })
        (pkgs.lib.filterAttrs
          (name: _: (match "${prefix}:.*" name) != null)
          inputs);

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            vimPlugins =
              prev.vimPlugins
              // (pkgs.lib.mapAttrs (
                pname: src:
                  prev.vimPlugins."${pname}".overrideAttrs (old: {
                    version = src.shortRev;
                    inherit src;
                  })
              ) (inputsMatching "plugin"))
              // (
                pkgs.lib.mapAttrs (
                  pname: src:
                    prev.vimUtils.buildVimPlugin {
                      inherit pname src;
                      version = src.shortRev;
                    }
                ) (inputsMatching "external-plugin")
              );
          })
          (final: prev: {
            vimPlugins =
              prev.vimPlugins
              // {
                nvim-treesitter = prev.vimPlugins.nvim-treesitter.overrideAttrs (
                  prev.callPackage ./nvim-treesitter/override.nix {} final.vimPlugins prev.vimPlugins
                );
              };
          })
        ];
      };

      nixvim' = nixvim.legacyPackages."${system}";
      nvim = nixvim'.makeNixvimWithModule {inherit module pkgs;};
    in {
      formatter."${system}" = pkgs.alejandra;

      devShells."${system}".default = pkgs.mkShell {
        packages = [nvim];
      };
      packages."${system}" = {
        inherit nvim;
        inherit (pkgs.vimPlugins) nvim-treesitter;

        # Treesitter auto update
        upstream = module.package;
        update-nvim-treesitter = pkgs.callPackage ./nvim-treesitter {
          inherit (self.packages."${system}") nvim-treesitter upstream;
        };

        default = nvim;
      };
    };
}
