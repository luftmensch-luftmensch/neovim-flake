{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.todo-comments;

in {
  options.vim.todo-comments = {
    enable = mkEnableOption "Enable todo-comments support";
    customKeywords = mkEnableOption "Enable custom keywords";
    mergeKeyworks = mkEnableOption "Mere custom keywords";
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg: if cond then msg else "";
    in {
      vim.startPlugins = [
        "todo-comments"
      ];

      vim.luaConfigRC.todo-comments = nvim.dag.entryAnywhere ''
      -- [todo-comments setup] --
      require("todo-comments").setup {
        ${writeIf cfg.customKeywords ''
        keywords = {
          FIX = {
            icon = " ", -- icon used for the sign, and in search results
            color = "error", -- can be a hex color, or a named color (see below)
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
            -- signs = false, -- configure signs for some keywords individually
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning", alt = { "HACK", "DRAGONS" } },
          WARN = { icon = " ", color = "warning", alt = { "WARNING", "WARNING", "WARN" } },
          PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE", "PERF", "PERFORMANCE" } },
          NOTE = { icon = " ", color = "hint", alt = { "INFO", "NOTE", "INFO" } },
        },
        ''}
        merge_keywords = ${boolToString cfg.mergeKeyworks}
      }
      
      '';
      
    }
  );
  
}
