{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
	options.colorschemes.moonfly = {
		enable = mkEnableOption "A dark charcoal theme for modern Neovim & classic Vim";
	};

	config = let
		cfg = config.colorschemes.moonfly;
	in
		mkIf cfg.enable {
			extraPlugins = with pkgs.vimPlugins; [vim-moonfly-colors];

			extraConfigLua = ''
				vim.cmd([[colorscheme moonfly]])
				'';
		};
}

