local languages = {
  "lua", "php", "blade",
  "html", "css", "javascript", "json", "typescript",
  "c", "java", 
  "markdown", "markdown_inline"
};

return {
  "nvim-treesitter/nvim-treesitter",
  branch = 'master',
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = languages,
      highlight = {enable = true},
      indent = {
        enable = true,
      },
    })
  end
}
