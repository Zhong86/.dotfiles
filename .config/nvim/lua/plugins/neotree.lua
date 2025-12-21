return  {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", 
  },
  vim.keymap.set('n', '<leader>f', ':Neotree filesystem reveal left<CR>', {})

}
