{
  description = "Neovim on steroid w/ flakes";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";

    #### ------------------------- External plugins ------------------------- ####

    # Code images
    "external-plugin:nvim-silicon" = {
      url = "github:michaelrommel/nvim-silicon";
      flake = false;
    };
  };

  outputs =
    {
      nixvim,
      ...
    }@inputs:
    let
      lib = import ./lib { inherit inputs; };
      utils = import ./utils { inherit (inputs.nixpkgs) lib; };
      inherit (lib) system pkgs;
      nixvim' = nixvim.legacyPackages.${system};
      nixvimModule = {
        inherit pkgs;
        module = import ./config;
        extraSpecialArgs = { inherit utils; };
      };
      nvim = nixvim'.makeNixvimWithModule nixvimModule;
    in
    {
      formatter."${system}" = pkgs.nixfmt-rfc-style;
      packages."${system}".default = nvim;
      devShells."${system}".default = pkgs.mkShell { packages = [ nvim ]; };
    };
}
