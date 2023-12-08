{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
	options.colorschemes.adwaita = {
		enable = mkEnableOption "Neovim colorscheme using Gnome Adwaita syntax";

		package = mkOption {
			type = types.package;
			default = pkgs.vimPlugins.adwaita-nvim;
			description = "Package to use for adwaita theme";
		};
	};

	config = let
		cfg = config.colorschemes.adwaita;

	in
		mkIf cfg.enable {
			extraPlugins = [cfg.package];

			extraConfigLua = ''
				vim.g.adwaita_darker = true -- for darker version
				vim.g.adwaita_disable_cursorline = true -- to disable cursorline
				vim.g.adwaita_transparent = true -- makes the background transparent
				-- setup must be called before loading
				vim.cmd([[colorscheme adwaita]])
				'';
		};
}
