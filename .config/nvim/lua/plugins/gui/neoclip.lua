return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    {'nvim-telescope/telescope.nvim'},
  },
  config = function()
    require('neoclip').setup({
      keys = {
        telescope = {
          i = {
            paste = { '<cr>', '<c-p>' },
          }
        }
      }
    })
    vim.keymap.set('n', '<leader>y', ':Telescope neoclip<CR>', {})
  end
}
