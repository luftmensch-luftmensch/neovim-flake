{
  lib,
  pkgs,
  config,
  helpers,
  ...
}:
{
  config = {
    plugins = {
      # Treesitter
      treesitter = {
        enable = true;
        settings = {
          indent.enable = true;
          highlight.enable = true;
        };
        nixvimInjections = true;

        grammarPackages =
          with config.plugins.treesitter.package.passthru.builtGrammars;
          [
            c
            cpp
            dart
            lua
            nix
            python
            sql
          ]
          ++ [
            vim
            vimdoc
          ]
          ++ [
            gitattributes
            gitcommit
            gitignore
            git_rebase
          ]
          ++ [
            bash
            regex
            dockerfile
            diff
            latex
          ]
          ++ [
            make
            meson
            ninja
          ]
          ++ [
            markdown
            markdown_inline
            rst
          ]
          ++ [
            ini
            json
            toml
            yaml
          ]
          ++ [
            html
            javascript
            css
          ];
      };

      treesitter-refactor = {
        enable = true;
        highlightDefinitions = {
          enable = true;
          clearOnCursorMove = true;
        };
        smartRename.enable = true;
        navigation.enable = true;
      };

      # Disabled it as I found it pretty annoying
      treesitter-context.enable = false;
    };
  };
}
