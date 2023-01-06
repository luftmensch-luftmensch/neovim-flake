{

  nightfox = {
    setup = { style ? "carbonfox" }: ''
      require('nightfox').setup({
        options = {
          styles = {
            comments = "italic",
            keywords = "bold",
            types = "italic,bold",
          }
        }
      })
      -- setup must be called before loading
      vim.cmd("colorscheme ${style}")
    '';
    styles = [ "nightfox" "dayfox" "dawnfox" "duskfox"  "nordfox" "terafox" "carbonfox" ];
  };

  onedark = {
    setup = { style ? "dark" }: ''
      -- OneDark theme
      require('onedark').setup {
        style = "${style}"
      }
      require('onedark').load()
    '';
    styles = [ "dark" "darker" "cool" "deep" "warm" "warmer" ];
  };

  moonfly = {
    setup = { style ? "moonfly" }: ''
      vim.cmd[[colorscheme ${style}]]
    '';
    styles = [ "moonfly" ];
  };

}
