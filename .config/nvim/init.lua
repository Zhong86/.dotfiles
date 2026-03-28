local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

--PLUGINS
require("vim-options")
require("lazy").setup({
  { import = "plugins.languages" },
  { import = "plugins.gui" }, 
  { import = "plugins.code" }
})

--TODO CUSTOM PLUGINS
local todoFloat = require("todoFloat")
todoFloat.setup({
  targetFile = "~/Documents/todo.md"
})

require("Functions.javaFile")

vim.diagnostic.config({
  virtual_text = true, -- Show errors as inline text
  signs = true,        -- Show signs in the sign column
  underline = true,    -- Underline errors
  update_in_insert = false,
  severity_sort = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  }
})

-- Enable cursorline and highlight only the line number
vim.o.cursorline = true
vim.o.cursorlineopt = "number"

-- Customize the highlight group for the current line number (bold + foreground color)
vim.cmd("autocmd ColorScheme * highlight CursorLineNr guifg=#F5E0DC gui=bold") -- example Catppuccin pink color

-- Optionally set it once immediately if colorscheme already loaded
vim.cmd("highlight CursorLineNr guifg=#F5E0DC gui=bold")
