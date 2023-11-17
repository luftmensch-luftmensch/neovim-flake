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

    ### ------------------------- Libraries ------------------------- ###
    "plugin:plenary-nvim" = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # UI Component Library for Neovim
    "plugin:nui-nvim" = {
      url = "github:MunifTanjim/nui.nvim";
      flake = false;
    };

    ### ------------------------- Lsp ------------------------- ###

    # Base configuration for Neovim LSP setup
    "plugin:nvim-lspconfig" = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    # VSCode-like pictograms for neovim lsp completion items
    "plugin:lspkind-nvim" = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };

    ## Language support for C/C++ using Clang ##
    "plugin:clangd_extensions-nvim" = {
      url = "github:p00f/clangd_extensions.nvim";
      flake = false;
    };

    ## Language support for rust ##
    "plugin:rust-tools-nvim" = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    ### ------------------------- Coding support ------------------------- ###

    # File explorer tree
    "plugin:nvim-tree-lua" = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };

    # Comments on steroids
    "plugin:comment-nvim" = {
      url = "github:numtostr/comment.nvim";
      flake = false;
    };

    # Indent guides for Neovim
    "plugin:indent-blankline-nvim" = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };

    # Incremental LSP renaming based on Neovim's command-preview feature
    "plugin:inc-rename-nvim" = {
      url = "github:smjonas/inc-rename.nvim";
      flake = false;
    };

    # Signature helper
    "plugin:neodev" = {
      url = "github:folke/neodev.nvim";
      flake = false;
    };

    ### ------------------------- Treesitter ------------------------- ###

    # Neovim Treesitter configurations and abstraction layer
    "plugin:nvim-treesitter" = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };

    # Treesitter module in order to show code context
    "plugin:nvim-treesitter-context" = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    # Treesitter module in order to refactor code
    "plugin:nvim-treesitter-refactor" = {
      url = "github:nvim-treesitter/nvim-treesitter-refactor";
      flake = false;
    };

    ### ------------------------- Telescope ------------------------- ###

    # Find, Filter, Preview, Pick. All lua, all the time
    "plugin:telescope-nvim" = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    "plugin:telescope-ui-select-nvim" = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };

    ### ------------------------- Completion ------------------------- ###
    # Completion plugin for neovim
    "plugin:nvim-cmp" = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };

    # nvim-cmp source for buffer words
    "plugin:cmp-buffer" = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };

    # nvim-cmp source for neovim builtin LSP client
    "plugin:cmp-nvim-lsp" = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };

    # nvim-cmp source for path
    "plugin:cmp-path" = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };

    # luasnip completion source for nvim-cmp
    "plugin:cmp_luasnip" = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };

    ### ------------------------- Snippets ------------------------- ###
    "plugin:luasnip" = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };

    ### ------------------------- Git ------------------------- ###

    # Reveal the commit messages under the cursor
    "plugin:git-messenger-vim" = {
      url = "github:rhysd/git-messenger.vim";
      flake = false;
    };

    # Git integration for buffers
    "plugin:gitsigns-nvim" = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    ### ------------------------- UI & Theming ------------------------- ###
    "plugin:nightfox" = {
      url = "github:EdenEast/nightfox.nvim";
      flake = false;
    };

    "external-plugin:modus-theme" = {
      url = "github:miikanissi/modus-themes.nvim";
      flake = false;
    };

    # Statusline status line
    "external-plugin:staline-nvim" = {
      url = "github:tamton-aquib/staline.nvim";
      flake = false;
    };

    # Adds file type icons to neovim
    "plugin:nvim-web-devicons" = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    ### ------------------------- Miscellaneous ------------------------- ###
    # Network Resource Manager
    "plugin:netman-nvim" = {
      url = "github:miversen33/netman.nvim";
      flake = false;
    };

    # Notification manager for NeoVim
    "plugin:nvim-notify" = {
      url = "github:rcarriga/nvim-notify";
      flake = false;
    };

    # Boost neovim % (Modern matchit and matchparen)
    "plugin:vim-matchup" = {
      url = "github:andymass/vim-matchup";
      flake = false;
    };

    # Buffer tools
    "plugin:bufdelete-nvim" = {
      url = "github:famiu/bufdelete.nvim";
      flake = false;
    };

    ### ------------------------- File type related ------------------------- ###
    "plugin:markdown-preview-nvim" = {
      url = "github:iamcco/markdown-preview.nvim?rev=02cc3874738bc0f86e4b91f09b8a0ac88aef8e96";
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
