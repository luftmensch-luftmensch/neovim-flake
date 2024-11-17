{
  lib,
  pkgs,
  config,
  helpers,
  ...
}:
{
  config.keymaps =
    let
      modeKeys = mode: lib.attrsets.mapAttrsToList (key: action: { inherit key action mode; });
      nm = modeKeys [ "n" ];
      vs = modeKeys [ "v" ];
    in
    helpers.keymaps.mkKeymaps { options.silent = true; } (nm {
      "<Esc>" = "<cmd>nohlsearch<CR>";

      # Buffers
      "<M-[>" = "<cmd>bprevious<CR>";
      "<M-]>" = "<cmd>bnext<CR>";

      # Splitting & Window management
      "<leader>v" = "<cmd>vsplit<CR>";
      "<leader>h" = "<cmd>split<CR>";
      "<leader>x" = "<cmd>only<CR>"; # close all but current window (in a single tab, aka close all other splits)
      "<C-M-k>" = "<cmd>bufdo bwipeout<CR>"; # close all buffers opened
      "<leader>z" = "<cmd>bdelete<CR>"; # close focused window/buffer
      # Keybinds to make split navigation easier
      "<C-h>" = "<C-w><C-h>";
      "<C-j>" = "<C-w><C-j>";
      "<C-k>" = "<C-w><C-k>";
      "<C-l>" = "<C-w><C-l>";
    })
    ++ (vs {
      # Retain selection in visual mode when indenting blocks
      "<" = "<gv";
      ">" = ">gv";
    });

}
