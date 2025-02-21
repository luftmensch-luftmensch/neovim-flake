{
  helpers,
  utils,
  ...
}:
{
  config = {
    keymaps = helpers.keymaps.mkKeymaps { options.silent = true; } (
      utils.nkmap { "<leader>g." = ":Neogit cwd=./<CR>"; }
    );

    plugins = {
      gitmessenger.enable = true;
      neogit = {
        enable = true;
        settings = {
          auto_refresh = true;
          disable_commit_confirmation = true;
          use_magit_keybindings = true;
          commit_popup.kind = "split";
        };
      };
      gitsigns = {
        enable = true;
        settings = {
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 200;
            ignoreWhitespace = false;
          };
          current_line_blame_formatter_nc = "   <author> | <author_time:%h %d, %Y> | <summary>";
          signs = {
            add.text = " ";
            change.text = " ";
            delete.text = " ";
            untracked.text = "";
            topdelete.text = "󱂥 ";
            changedelete.text = "󱂧 ";
          };
        };
      };

    };
  };
}
