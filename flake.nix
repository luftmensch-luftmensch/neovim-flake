{
  description = "Neovim on steroid w/ flakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    # For generating documentation website
    nmd = {
      url = "gitlab:rycee/nmd";
      flake = false;
    };

    # LSP
    nvim-lspconfig = {
      # url = "github:neovim/nvim-lspconfig?ref=v0.1.3";
      # Use master for nil_ls
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };

    # Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };

    # VSCode-like pictograms for neovim lsp completion items
    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };

    # Diagnostics, references, telescope results, quickfix and location list
    trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };

    # VSCode bulb for neovim's built-in LSP.
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };

    # TREESITTER
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };

    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    lspsaga = {
      url = "github:tami5/lspsaga.nvim";
      flake = false;
    };


    nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };

    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };

    # Standalone UI for nvim-lsp progress
    nvim-fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };

    # Incremental LSP renaming based on Neovim's command-preview feature. 
    inc-rename = {
      url = "github:smjonas/inc-rename.nvim";
      flake = false;
    };

    # LANGUAGE RELATED
    clangd_extensions = {
      url = "github:p00f/clangd_extensions.nvim";
      flake = false;
    };

    #rust-tools = {
    #  url = "github:simrat39/rust-tools.nvim";
    #  flake = false;
    #};

    # Copying/Registers
    registers = {
      url = "github:tversteeg/registers.nvim";
      flake = false;
    };
    nvim-neoclip = {
      url = "github:AckslD/nvim-neoclip.lua";
      flake = false;
    };

    # Telescope
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    telescope-ui-select = {
      url = "github:nvim-telescope/telescope-ui-select.nvim";
      flake = false;
    };

    # Terminal
    toggleterm = {
      url = "github:akinsho/toggleterm.nvim";
      flake = false;
    };

    # Langauge server (use master instead of nixpkgs)
    rnix-lsp.url = "github:nix-community/rnix-lsp";

    # Language server for nix
    nil = {
      url = "github:oxalica/nil";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Filetrees
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    # Tablines
    nvim-bufferline-lua = {
      url = "github:akinsho/nvim-bufferline.lua?ref=v3.0.1";
      flake = false;
    };

    # Statuslines
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };

    # Autocompletes
    nvim-compe = {
      url = "github:hrsh7th/nvim-compe";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    # snippets
    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    # Autopairs
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };

    # Commenting
    kommentary = {
      url = "github:b3nj5m1n/kommentary";
      flake = false;
    };
    todo-comments = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };

    # Buffer tools
    bufdelete-nvim = {
      url = "github:famiu/bufdelete.nvim";
      flake = false;
    };

    # Themes
    nightfox = {
      url = "github:EdenEast/nightfox.nvim";
      flake = false;
    };

    moonfly = {
      url = "github:bluz71/vim-moonfly-colors";
      flake = false;
    };

    onedark = {
      url = "github:navarasu/onedark.nvim";
      flake = false;
    };

    # Rust crates
    #crates-nvim = {
    #  url = "github:Saecki/crates.nvim";
    #  flake = false;
    #};

    # Visuals
    nvim-cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };

    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };

    # GIT
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    # Key binding help
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # Markdown
    glow-nvim = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };

    # Tidal cycles
    #tidalcycles = {
    #  url = "github:mitchmindtree/tidalcycles.nix";
    #  inputs.vim-tidal-src.url = "github:tidalcycles/vim-tidal";
    #};

    # Plenary (required by crates-nvim)
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    modulesWithInputs = import ./modules {inherit inputs;};

    neovimConfiguration = {
      modules ? [],
      pkgs,
      lib ? pkgs.lib,
      check ? true,
      extraSpecialArgs ? {},
    }:
      modulesWithInputs {
        inherit pkgs lib check extraSpecialArgs;
        configuration = {...}: {
          imports = modules;
        };
      };

    nvimBin = pkg: "${pkg}/bin/nvim";

    buildPkg = pkgs: modules:
      (neovimConfiguration {
        inherit pkgs modules;
      })
      .neovim;

    mainConfig = isMaximal: {
      config = {
        vim.viAlias = false;
        vim.vimAlias = true;
        vim.lastStatus = 3;
        vim.lsp = {
          enable = true;
          signatures = true;
          uiProgressInfo = true;
          lang = {
            clang.enable = true;
            nix.enable = true;
            nix.server = "nil";
          };
        };

        vim.visuals = {
          enable = true;
          nvimWebDevicons.enable = true;
          lspkind.enable = true;
          indentBlankline = {
            enable = true;
            fillChar = "";
            eolChar = "";
            showCurrContext = true;
          };
          highlight = {
            enable = true;
            cursorWord = {
              enable      = true;
              minLenght   = 3;
              hlUnderline = true;
            };
          };
        };
        vim.statusline.lualine = {
          enable = true;
          theme = "auto";
        };
        vim.theme = {
          enable = true;
          name  = "nightfox";
          style = "carbonfox";
          #name  = "moonfly";
          #style = "moonfly";
        };
        vim.autopairs.enable = true;
        vim.autocomplete = {
          enable = true;
          type = "nvim-cmp";
        };

        vim.terminal = {
          enable    = true;
          position = "float";
        };

        vim.filetree = {
          nvimTreeLua = {
            enable = true;
            openOnSetup = false;
          };
        };
        vim.tabline.nvimBufferline.enable = true;
        #vim.treesitter = {
        #  enable = true;
        #  context.enable = true;
        #};
        vim.keys = {
          enable = true;
          whichKey.enable = true;
        };
        vim.telescope = {
          enable = true;
        };
        vim.markdown = {
          enable = true;
          glow.enable = true;
        };
        vim.git = {
          enable = true;
          gitsigns.enable = true;
        };
      };
    };

    nixConfig = mainConfig false;
    maximalConfig = mainConfig true;
  in
    {
      lib = {
        nvim = (import ./modules/lib/stdlib-extended.nix nixpkgs.lib).nvim;
        inherit neovimConfiguration;
      };

      overlays.default = final: prev: {
        inherit neovimConfiguration;
        neovim-nix = buildPkg prev [nixConfig];
        neovim-maximal = buildPkg prev [maximalConfig];
        #neovim-tidal = buildPkg prev [tidalConfig];
      };
    }
    // (flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          #inputs.tidalcycles.overlays.default
          (final: prev: {
            rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
            nil = inputs.nil.packages.${system}.default;
          })
        ];
      };

      docs = import ./docs {
        inherit pkgs;
        nmdSrc = inputs.nmd;
      };

      #tidalPkg = buildPkg pkgs [tidalConfig];
      nixPkg = buildPkg pkgs [nixConfig];
      maximalPkg = buildPkg pkgs [maximalConfig];
    in {
      apps =
        rec {
          nix = {
            type = "app";
            program = nvimBin nixPkg;
          };
          maximal = {
            type = "app";
            program = nvimBin maximalPkg;
          };
          default = nix;
        };
        #// (
        #  if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
        #  then {
        #    #tidal = {
        #    #  type = "app";
        #    #  #program = nvimBin tidalPkg;
        #    #};
        #  }
        #  else {}
        #);

      devShells.default = pkgs.mkShell {nativeBuildInputs = [nixPkg];};

      packages =
        {
          docs-html = docs.manual.html;
          docs-manpages = docs.manPages;
          docs-json = docs.options.json;
          default = nixPkg;
          nix = nixPkg;
          maximal = maximalPkg;
        };
        #// (
        #  if !(builtins.elem system ["aarch64-darwin" "x86_64-darwin"])
        #  then {
        #    #tidal = tidalPkg;
        #  }
        #  else {}
        #);
    }));
}
