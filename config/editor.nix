{
  lib,
  config,
  helpers,
  utils,
  ...
}:
{
  config = {
    keymaps = helpers.keymaps.mkKeymaps { options.silent = true; } (
      utils.nkmap (
        lib.optionalAttrs config.plugins.undotree.enable {
          "<leader>ut" = "<cmd>UndotreeToggle<CR>";
        }
      )
    );

    plugins = {
      indent-blankline = {
        enable = true;
        settings = {
          scope = {
            enabled = true;
            show_start = true;
          };
        };
      };

      todo-comments = {
        enable = true;
        settings = {
          colors = {
            error = [
              "DiagnosticError"
              "ErrorMsg"
              "#ED8796"
            ];
            warning = [
              "DiagnosticWarn"
              "WarningMsg"
              "#EED49F"
            ];
            info = [
              "DiagnosticInfo"
              "#EED49F"
            ];
            default = [
              "Identifier"
              "#F5A97F"
            ];
            test = [
              "Identifier"
              "#8AADF4"
            ];
          };
        };
      };

      undotree = {
        enable = true;
        settings = {
          autoOpenDiff = true;
          focusOnToggle = true;
        };
      };

      navic = {
        enable = true;
        settings = {
          separator = "  ";
          highlight = true;
          depthLimit = 5;
          lsp.autoAttach = true;
          icons = {
            Array = "󱃵  ";
            Boolean = "  ";
            Class = "  ";
            Constant = "  ";
            Constructor = "  ";
            Enum = " ";
            EnumMember = " ";
            Event = " ";
            Field = "󰽏 ";
            File = " ";
            Function = "󰡱 ";
            Interface = " ";
            Key = "  ";
            Method = " ";
            Module = "󰕳 ";
            Namespace = " ";
            Null = "󰟢 ";
            Number = " ";
            Object = "  ";
            Operator = " ";
            Package = "󰏖 ";
            String = " ";
            Struct = " ";
            TypeParameter = " ";
            Variable = " ";
          };
        };
      };

      illuminate = {
        enable = true;
        underCursor = false;
        filetypesDenylist = [
          "Outline"
          "TelescopePrompt"
          "alpha"
          "reason"
        ];
      };
    };
  };
}
