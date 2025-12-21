return {
  "nvim-lualine/lualine.nvim", 
  config = function()
    require('lualine').setup({
      options = {
        theme = 'gruvbox_dark'
      }, 
      sections = {
        lualine_c = {
          {
            'filename', 
            path = 1
          }
        },
        lualine_x = {},
        lualine_y = {'filetype' },
        lualine_z = {'hostname'}
      }, 
      inactive_sections = {
        lualine_c = { {'filename', path = 1 } }
      }
    })
  end
}
