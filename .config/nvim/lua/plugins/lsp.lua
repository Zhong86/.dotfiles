return {
  {
    'williamboman/mason.nvim', 
    config = function() 
      require('mason').setup()
    end
  }, 
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        ensure_installed = { 'intelephense', 'jdtls'}, 
        automatic_enable = true
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
      vim.lsp.config('lua_ls', {})
      vim.lsp.config('intelephense', {})
      vim.lsp.config('jdtls', {})
    end
  }, 
  -- JAVA
  {
    "mfussenegger/nvim-jdtls",
    ft = "java", -- only loads for .java files = saves RAM
  }
}
