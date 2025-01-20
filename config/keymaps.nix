{
  lib,
  pkgs,
  config,
  helpers,
  utils,
  ...
}:
{

  config = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps =
      helpers.keymaps.mkKeymaps { options.silent = true; } (
        utils.nkmap {
          "<esc>" = "<cmd>noh<cr><esc>"; # Escape and Clear hlsearch
          "<C-Up>" = "<cmd>resize +2<cr>"; # Increase Window Height
          "<C-Down>" = "<cmd>resize -2<cr>"; # Decrease Window Height
          "<C-Left>" = "<cmd>vertical resize +2<cr>"; # Increase Window Width
          "<C-Right>" = "<cmd>vertical resize -2<cr>"; # Decrease Window Width
          "<A-j>" = "<cmd>m .+1<cr>=="; # Move Down
          "<A-k>" = "<cmd>m .-2<cr>=="; # Move Up
          "<M-[>" = "<cmd>bprevious<CR>";
          "<M-]>" = "<cmd>bnext<CR>";
          "]d" = "diagnostic_goto(true)"; # Next Diagnostic
          "[d" = "diagnostic_goto(false)"; # Prev Diagnostic

          "]e" = "diagnostic_goto(true 'ERROR')"; # Next Error
          "[e" = "diagnostic_goto(false 'ERROR')"; # Prev Error

          "]w" = "diagnostic_goto(true 'WARN')"; # Next Warning
          "[w" = "diagnostic_goto(false 'WARN')"; # Prev Warning
          "<leader>qq" = "<cmd>qa<cr>"; # Quit All
          "<leader>ur" = "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>"; # Redraw / Clear hlsearch / Diff Update
          "<leader>cd" = "vim.diagnostic.open_float";
          "<leader>ui" = "vim.show_pos";
          "<leader>ww" = "<C-W>p"; # Other Window
          "<leader>wd" = "<C-W>c"; # Delete Window
          "<leader>w-" = "<C-W>s"; # Split Window Below
          "<leader>w|" = "<C-W>v"; # Split Window Right
          "<leader>-" = "<C-W>s"; # Split Window Below
          "<leader>|" = "<C-W>v"; # Split Window Right

          "<leader>h" = "<C-W>s"; # Split Window Below
          "<leader>v" = "<C-W>v"; # Split Window Right
          "<leader><tab>l" = "<cmd>tablast<cr>"; # Last Tab
          "<leader><tab>f" = "<cmd>tabfirst<cr>"; # First Tab
          "<leader><tab><tab>" = "<cmd>tabnew<cr>"; # New Tab
          "<leader><tab>[" = "<cmd>tabprevious<cr>"; # Previous Tab
          "<leader><tab>]" = "<cmd>tabprevious<cr>"; # Next Tab
          "<leader><tab>d" = "<cmd>tabclose<cr>"; # Next Tab

          "<leader>x" = "<cmd>only<CR>"; # close all but current window (in a single tab, aka close all other splits)
          "<leader>z" = "<cmd>bdelete<CR>"; # close focused window/buffer
          "<C-M-k>" = "<cmd>bufdo bwipeout<CR>"; # close all buffers opened
        }
      )
      ++ (utils.vkmap {
        "<" = "<gv";
        ">" = ">gv";
        "<A-j>" = ":m '>+1<cr>gv=gv"; # Move Down
        "<A-k>" = ":m '<-2<cr>gv=gv"; # Move Up
      })
      ++ (utils.ikmap {
        "<esc>" = "<cmd>noh<cr><esc>"; # Escape and Clear hlsearch
        "<A-j>" = "<esc><cmd>m .+1<cr>==gi"; # Move Down
        "<A-k>" = "<esc><cmd>m .-2<cr>==gi"; # Move Up
      })
      ++ (utils.tkmap {
        "<C-h>" = "<cmd>wincmd h<cr>"; # Go to Left Window
        "<C-l>" = "<cmd>wincmd l<cr>"; # Go to Right Window
        "<C-j>" = "<cmd>wincmd j<cr>"; # Go to Lower Window
        "<C-k>" = "<cmd>wincmd k<cr>"; # Go to Upper Window
      });
  };
}
