--BASIC CUSTOMIZATION
vim.opt.number = true
vim.g.mapleader = " "
vim.cmd("set cindent")
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set ignorecase")

--KEYBINDS
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'LSP Info'})
vim.keymap.set('n', 'def', vim.lsp.buf.definition, { desc = "" })
vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, { desc = "Code Actions"})
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show full diagnostic" })
vim.keymap.set('n', "<leader>td", ":Todo<CR>", {silent = true, desc="Todo List"})
vim.keymap.set('n', "<leader>cs", ":Telescope colorscheme<CR>", {desc="Change colorscheme"})

--New Java file
vim.keymap.set("n", "<leader>nj", function()
  vim.ui.input({ prompt = "Class name: " }, function(name)
    if name then
      vim.cmd("Java " .. name)
    end
  end)
end, { desc = "New Java file" })
--Springboot Java file
vim.keymap.set("n", "<leader>ns", function()
  vim.ui.input({ prompt = "Class name: " }, function(name)
    if name then
      vim.cmd("Springboot " .. name)
    end
  end)
end, { desc = "New Java file for Springboot" })

--Barbar
local barbar_state = true
vim.keymap.set('n', '<leader>tb', function()
  barbar_state = not barbar_state
  if barbar_state then
    vim.o.showtabline = 2
  else
    vim.o.showtabline = 0
  end
  print('Barbar: ' .. (barbar_state and 'enabled' or 'disabled'))
end, { desc = 'Toggle barbar' })
vim.keymap.set('n', '<A-,>', '<Cmd>BufferPrevious<CR>')
vim.keymap.set('n', '<A-.>', '<Cmd>BufferNext<CR>')
vim.keymap.set('n', '<A-c>', '<Cmd>BufferClose<CR>')

