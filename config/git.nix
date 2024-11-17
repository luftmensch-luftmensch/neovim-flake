{
  lib,
  pkgs,
  config,
  helpers,
  ...
}:
{
  config = {

    ### MAPPINGS ###
    keymaps =
      let
        modeKeys = mode: lib.attrsets.mapAttrsToList (key: action: { inherit key action mode; });
        nm = modeKeys [ "n" ];
      in
      helpers.keymaps.mkKeymaps { options.silent = true; } (nm {
        "<leader>g." = ":Neogit cwd=./<CR>";
      });

    plugins = {
      gitsigns = {
        enable = true;
        settings = {
          trouble = config.plugins.trouble.enable;
          current_line_blame = false;
          current_line_blame_opts = {
            virt_text = true;
            virt_text_pos = "eol";
            delay = 200;
            ignoreWhitespace = false;
          };
          current_line_blame_formatter_nc = "   <author> | <author_time:%h %d, %Y> | <summary>";
        };
      };

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

    };
  };
}
