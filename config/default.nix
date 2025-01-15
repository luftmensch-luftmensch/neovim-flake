_: {
  imports = [
    # General Configuration
    ./settings.nix
    ./keymaps.nix

    # Plugins configuration
    ./completion.nix
    ./git.nix
    ./lsp.nix
    ./extras.nix
    ./explorers.nix
    ./ui.nix
    ./treesitter.nix

    ./plugins
  ];
}
