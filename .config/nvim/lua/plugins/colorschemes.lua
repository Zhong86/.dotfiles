return { 
  {
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
    -- config = function()
      -- vim.cmd.colorscheme "catppuccin"
    -- end
  }, 
  {
    "rebelot/kanagawa.nvim", 
    name = "kanagawa", 
    priority = 1000, 
    config = function() 
      require('kanagawa').setup({
        background = {
          dark = "dragon"
        }
      })
      vim.cmd.colorscheme "kanagawa-dragon"
    end
  }
}
