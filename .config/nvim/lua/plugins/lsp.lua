return {
  {
    'williamboman/mason.nvim', 
    config = function() 
      require('mason').setup()
    end
  }, 
  -- {
  --   'williamboman/mason-lspconfig.nvim',
  --   dependencies = { 'williamboman/mason.nvim' },
  --   config = function()
  --     require('mason-lspconfig').setup()  -- REQUIRED!
  --   end
  -- },
  {
    'neovim/nvim-lspconfig',
    version = "0.1.*",
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.intelephense.setup {}
      lspconfig.jdtls.setup {}  -- Optional, nvim-jdtls overrides this
    end
  },
  -- JAVA (keep as-is, perfect)
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  }
}
