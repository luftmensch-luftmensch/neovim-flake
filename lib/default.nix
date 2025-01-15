{ inputs, ... }:
rec {
  system = "x86_64-linux";

  inputsMatching =
    with builtins;
    prefix:
    pkgs.lib.mapAttrs' (prefixedName: value: {
      name = substring (stringLength "${prefix}:") (stringLength prefixedName) prefixedName;
      inherit value;
    }) (pkgs.lib.filterAttrs (name: _: (match "${prefix}:.*" name) != null) inputs);

  pkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [
      (_final: prev: {
        vimPlugins =
          prev.vimPlugins
          // (pkgs.lib.mapAttrs (
            pname: src:
            prev.vimPlugins."${pname}".overrideAttrs (_old: {
              version = src.shortRev;
              inherit src;
            })
          ) (inputsMatching "plugin"))
          // (pkgs.lib.mapAttrs (
            pname: src:
            prev.vimUtils.buildVimPlugin {
              inherit pname src;
              version = src.shortRev;
            }
          ) (inputsMatching "external-plugin"));
      })
    ];
  };
}
