{
  lib,
  pkgs,
  ...
}:
{
  config = {
    userCommands = {
      FormatDisable = {
        command.__raw = ''
          function(args)
            if args.bang then
              -- FormatDisable! will disable formatting just for this buffer
              vim.b.disable_autoformat = true
            else
              vim.g.disable_autoformat = true
            end
          end
        '';
        desc = "Disable autoformat-on-save";
        bang = true;
      };

      FormatEnable = {
        command.__raw = ''
          function()
            vim.b.disable_autoformat = false
            vim.g.disable_autoformat = false
          end
        '';
        desc = "Re-enable autoformat-on-save";
      };
      FormatToggle = {
        command.__raw = ''
          function(args)
            if args.bang then
              -- Toggle formatting for current buffer
              vim.b.disable_autoformat = not vim.b.disable_autoformat
            else
              -- Toggle formatting globally
              vim.g.disable_autoformat = not vim.g.disable_autoformat
            end
          end
        '';
        desc = "Toggle autoformat-on-save";
        bang = true;
      };
    };

    plugins = {
      conform-nvim = {
        enable = true;
        settings = {
          notify_on_error = true;
          format_on_save = {
            timeoutMs = 500;
            lspFallback = true;
          };

          formatters_by_ft = rec {
            html = [ "prettier" ];
            css = html;
            javascript = html;
            typescript = html;
            markdown = html;
            yaml = html;

            python = [
              "isort"
              "black"
            ];
            lua = [ "stylua" ];
            nix = [ "nixfmt" ];
            bash = [
              "shellcheck"
              "shfmt"
            ];
            json = [ "jq" ];
            tex = [ "latexindent" ];
            c = [ "clang-format" ]; # "astyle"
            # Use the "_" filetype to run formatters on filetypes that don't
            # have other formatters configured.
            "_" = [ "trim_whitespace" ];
            # Use the "*" filetype to run formatters on all filetypes.
            "*" = [ "codespell" ];
          };

          formatters = {
            black.command = "${lib.getExe pkgs.black}";
            isort.command = "${lib.getExe pkgs.isort}";
            nixfmt.command = "${lib.getExe pkgs.nixfmt}";
            alejandra.command = "${lib.getExe pkgs.alejandra}";
            jq.command = "${lib.getExe pkgs.jq}";
            prettier.command = "${lib.getExe pkgs.prettierd}";
            stylua.command = "${lib.getExe pkgs.stylua}";
            shellcheck.command = "${lib.getExe pkgs.shellcheck}";
            shfmt.command = "${lib.getExe pkgs.shfmt}";
            latexindent.command = "${pkgs.texlivePackages.latexindent}/bin/latexindent";
          };
        };
      };
      fidget = {
        enable = true;
        settings = {
          logger = {
            level = "warn"; # “off”, “error”, “warn”, “info”, “debug”, “trace”
            float_precision = 1.0e-2; # Limit the number of decimals displayed for floats
          };

          progress = {
            poll_rate = 0; # How and when to poll for progress messages
            suppress_on_insert = true; # Suppress new messages while in insert mode
            ignore_done_already = false; # Ignore new tasks that are already complete
            ignore_empty_message = false; # Ignore new tasks that don't contain a message

            # Clear notification group when LSP server detaches
            clear_on_detach = ''
              function(client_id)
                local client = vim.lsp.get_client_by_id(client_id)
                return client and client.name or nil
              end
            '';

            # How to get a progress message's notification group key
            notification_group = ''
              function(msg) return msg.lsp_client.name end
            '';
            ignore = [ ]; # List of LSP servers to ignore
            lsp.progress_ringbuf_size = 0; # Configure the nvim's LSP progress ring buffer size
            display = {
              render_limit = 16; # How many LSP messages to show at once
              done_ttl = 3; # How long a message should persist after completion
              done_icon = "✔"; # Icon shown when all LSP progress tasks are complete
              done_style = "Constant"; # Highlight group for completed LSP tasks
              progress_icon = {
                pattern = "dots";
                period = 1;
              }; # Icon shown when LSP progress tasks are in progress
              progress_style = "WarningMsg"; # Highlight group for in-progress LSP tasks
              group_style = "Title"; # Highlight group for group name (LSP server name)
              icon_style = "Question"; # Highlight group for group icons
              priority = 30; # Ordering priority for LSP notification group
              skip_history = true; # Whether progress notifications should be omitted from history
              format_message.__raw = ''
                require ("fidget.progress.display").default_format_message
              '';
              # How to format a progress message
              format_annote.__raw = ''
                function (msg) return msg.title end
              '';
              # How to format a progress annotation
              format_group_name.__raw = ''
                function (group) return tostring (group) end
              '';
              # How to format a progress notification group's name
              overrides.rust_analyzer.name = "rust-analyzer";
            };
          };
          notification = {
            poll_rate = 10; # How frequently to update and render notifications
            filter = "info"; # “off”, “error”, “warn”, “info”, “debug”, “trace”
            history_size = 128; # Number of removed messages to retain in history
            override_vim_notify = true;

            window = {
              normal_hl = "Comment";
              winblend = 0;
              border = "none"; # none, single, double, rounded, solid, shadow
              zindex = 45;
              max_width = 0;
              max_height = 0;
              x_padding = 1;
              y_padding = 0;
              align = "bottom";
              relative = "editor";
            };
            view = {
              stack_upwards = true; # Display notification items from bottom to top
              icon_separator = " "; # Separator between group name and icon
              group_separator = "---"; # Separator between notification groups
              group_separator_hl = "Comment"; # Highlight group used for group separator
            };
          };
        };
      };

      lsp-lines.enable = true;
      lsp-format.enable = true;
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          html.enable = true;
          lua_ls.enable = true;
          # nil_ls.enable = true;
          nixd = {
            enable = true;
            settings.formatting.command = [ (lib.getExe pkgs.nixfmt) ];
          };
          ts_ls.enable = true;
          marksman.enable = true;
          gopls.enable = true;
          terraformls.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
          clangd.enable = true;
          bashls.enable = true;
          pylsp = {
            enable = true;
            settings = {
              configurationSources = "flake8";
              plugins = {
                flake8.enabled = true;
                pylint.enabled = true;
              };
            };
          };

        };

        keymaps = {
          silent = true;
          lspBuf = {
            gd = "definition";
            ca = "code_action";

            gr = "references";
            gD = "declaration";
            gI = "implementation";
            gT = "type_definition";
            K = "hover";
            "<leader>cw" = "workspace_symbol";
            "<leader>cr" = "rename";
          };
          diagnostic = {
            "<leader>cd" = "open_float";
            "[d" = "goto_next";
            "]d" = "goto_prev";
          };
        };

        postConfig = ''
          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"})
          vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"})
          vim.diagnostic.config{float = {border="rounded"}};
          require('lspconfig.ui.windows').default_options = {border = "rounded"}
        '';
      };

      # VSCode-like pictograms for neovim lsp completion items
    };
  };
}
