{
  config,
  lib,
	pkgs,
  ...
}:
with lib; {
	options.colorschemes.citruszest = {
		enable = mkEnableOption "A vibrant and refreshing neovim colorscheme inspired by citrus fruits";
	};

	config = let
		cfg = config.colorschemes.citruszest;

	in
		mkIf cfg.enable {
			extraPlugins = with pkgs.vimPlugins; [citruszest-nvim];
			extraConfigLua = ''
				-- For using default config leave this empty.
				require("citruszest").setup({
						option = {
								transparent = false, -- Enable/Disable transparency
								italic = true,
								bold = true,
						},
						-- Override default highlight style in this table
						-- E.g If you want to override `Constant` highlight style
						style = {
						-- This will change Constant foreground color and make it bold.
						--	Constant = { fg = "#FFFFFF", bold = true}
						},
				})
				-- setup must be called before loading
				vim.cmd([[colorscheme citruszest]])
				'';
		};
}
