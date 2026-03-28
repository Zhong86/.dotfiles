function changeColor()
  local time = os.date("*t", os.time())
  local nowMin = time.hour * 60 + time.min
  local sixPm = 18 * 60
  if nowMin < sixPm then
    vim.cmd.colorscheme "kanagawa"
  else
    vim.cmd.colorscheme "tokyonight-moon"
  end
end

return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
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
      changeColor()
    end
  },
  {
    "folke/tokyonight.nvim",
    name = "tokyonight",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "moon"
      })
    end
  }
}
