return {
  {'romgrk/barbar.nvim',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() vim.g.barbar_auto_setup = false end,
    config = function()
      require('barbar').setup({
        sidebar_filetypes = {},
        offset = {0, 0},
        minimum_padding = 1,
        show_buffer_close_icon = false,
      }); 
    end
  },
}
