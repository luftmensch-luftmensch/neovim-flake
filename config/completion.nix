{
  lib,
  config,
  pkgs,
  ...
}:
let
  blink-providers = config.plugins.blink-cmp.settings.sources.providers;
in
{
  config.plugins = {
    blink-compat.enable = true;
    blink-ripgrep.enable = lib.hasAttr "ripgrep" blink-providers;
    blink-emoji.enable = lib.hasAttr "emoji" blink-providers;

    blink-cmp = {
      enable = true;
      settings = {
        appearance = {
          nerd_font_variant = "normal";
          use_nvim_cmp_as_default = true;
        };

        completion = {
          keyword.range = "full";

          # Display a preview of the selected item on the current line
          ghost_text.enabled = true;
          list = {

            max_items = 150;

            # Do not preselect nor auto_insert
            selection = {
              preselect = false;
              auto_insert = false;
            };

            # Do not cycle
            cycle = {
              from_bottom = false;
              from_top = false;
            };
          };

          documentation = {
            auto_show = true;
            auto_show_delay_ms = 350;
            update_delay_ms = 25;
            window.winblend = 20;
          };

          # How the completion items are drawn
          menu = {
            max_height = 15;
            draw = {
              padding = 1;
              columns.__raw = ''
                {
                   { 'item_idx', 'kind_icon', gap = 2 },
                   { 'label', 'label_description', gap = 1 },
                   { 'source_name' },
                }
              '';

              components = {
                item_idx = {
                  text.__raw = ''
                    function(ctx)
                      local item_address = { '🯱', '🯲', '🯳', '🯴', '🯵', '🯶', '🯷','🯸', '🯹', '🯰' }
                      return item_address[ctx.idx] or " "
                    end
                  '';
                  highlight = "BlinkCmpItemIdx";
                };
              };
            };
          };
        };

        # fuzzy.sorts = [
        #   "exact"
        #   "score"
        #   "sort_text"
        # ];

        keymap = {
          preset = "none";
          "<Tab>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];
          "<C-h>" = [
            "show_documentation"
            "hide_documentation"
          ];
          "<C-.>" = [
            "hide"
            "show"
          ];
          "<C-l>" = [ "select_and_accept" ];
          "<PageDown>" = [
            "scroll_documentation_down"
            "fallback"
          ];
          "<PageUp>" = [
            "scroll_documentation_up"
            "fallback"
          ];

          "<C-1>".__raw = ''{ function(cmp) cmp.accept({ index = 1 }) end }'';
          "<C-2>".__raw = ''{ function(cmp) cmp.accept({ index = 2 }) end }'';
          "<C-3>".__raw = ''{ function(cmp) cmp.accept({ index = 3 }) end }'';
          "<C-4>".__raw = ''{ function(cmp) cmp.accept({ index = 4 }) end }'';
          "<C-5>".__raw = ''{ function(cmp) cmp.accept({ index = 5 }) end }'';
          "<C-6>".__raw = ''{ function(cmp) cmp.accept({ index = 6 }) end }'';
          "<C-7>".__raw = ''{ function(cmp) cmp.accept({ index = 7 }) end }'';
          "<C-8>".__raw = ''{ function(cmp) cmp.accept({ index = 8 }) end }'';
          "<C-9>".__raw = ''{ function(cmp) cmp.accept({ index = 9 }) end }'';
          "<C-0>".__raw = ''{ function(cmp) cmp.accept({ index = 10 }) end }'';
        };

        signature = {
          enabled = true;
          window.direction_priority = [ "s" ];
        };

        sources = {
          default = [
            "lsp"
            "buffer"
            "path"
            "git"
            "calc"
            "omni"
            "ripgrep"
          ];

          cmdline.__raw = ''
            function()
              local type = vim.fn.getcmdtype()
              if type == "/" or type == "?" then
                return { "buffer" }
              end
              if type == ":" or type == "@" then
                return { "cmdline", "path" }
              end
              return {}
            end
          '';

          providers = {
            lsp = {
              name = "LSP";
              module = "blink.cmp.sources.lsp";
              score_offset = 90;
            };

            path = {
              name = "PATH";
              module = "blink.cmp.sources.path";
              score_offset = 25;
            };

            snippets = {
              name = "SNP";
              module = "blink.cmp.sources.snippets";
              score_offset = 95;
            };

            git = {
              name = "git";
              module = "blink.compat.source";
            };
            calc = {
              name = "calc";
              module = "blink.compat.source";
            };
            omni = {
              name = "omni";
              module = "blink.compat.source";
            };
            emoji = {
              module = "blink-emoji";
              name = "Emoji";
              score_offset = 15;
              opts.insert = true;
            };
            buffer = {
              name = "BUF";
              module = "blink.cmp.sources.buffer";
              score_offset = 95;
            };

            ripgrep = {
              module = "blink-ripgrep";
              name = "RIP";
              score_offset = 15;
              opts = {
                prefix_min_len = 3;
                project_root_marker = [
                  ".git"
                  ".env"
                  ".gitignore"
                  ".nvim"
                ];
                project_root_fallback = false;
              };
            };
          };
        };
      };
    };

    luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      fromVscode = [
        {
          lazyLoad = true;
          paths = "${pkgs.vimPlugins.friendly-snippets}";
        }
      ];
    };

    schemastore = {
      enable = true;
      json.enable = true;
      yaml.enable = true;
    };

  };
}
