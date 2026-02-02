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
        ensure_installed = { 'intelephense' }
      })
    end
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = { 'williamboman/mason-lspconfig.nvim' },
    config = function()
      vim.lsp.config('intelephense', {})
      vim.lsp.enable('intelephense')
    end
  }
}
