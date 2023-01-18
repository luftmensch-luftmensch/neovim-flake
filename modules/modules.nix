{
  pkgs,
  lib,
  check ? true,
}: let
  modules = [
    ./options
    ./completion
    ./theme
    ./core
    ./basic
    ./dashboard
    ./statusline
    ./tabline
    ./nvim-tree
    ./visuals
    ./lsp
    ./treesitter
    ./autopairs
    ./snippets
    ./keys
    ./telescope
    ./terminal
    ./git
    ./todo-comments
  ];

  pkgsModule = {config, ...}: {
    config = {
      _module.args.baseModules = modules;
      _module.args.pkgsPath = lib.mkDefault pkgs.path;
      _module.args.pkgs = lib.mkDefault pkgs;
      _module.check = check;
    };
  };
in
  modules ++ [pkgsModule]
