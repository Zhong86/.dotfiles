return {
  {
    'williamboman/mason.nvim', 
    config = function() 
      require('mason').setup()
    end
  }, 
  {
    'williamboman/mason-lspconfig.nvim',
    version = "1.31.0",
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-lspconfig').setup({
        automatic_enable = false
      })  -- REQUIRED!
    end
  },
  {
    'neovim/nvim-lspconfig',
    version = "0.1.*",
    dependencies = { 
      'williamboman/mason-lspconfig.nvim', 
      'hrsh7th/cmp-nvim-lsp'
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- PHP / Laravel
      lspconfig.intelephense.setup({
        capabilities = capabilities,
        settings = {
          intelephense = {
            environment = {
              phpVersion = "8.2",
              -- Tells intelephense where your project root is
              includePaths = {}
            },
            files = {
              maxSize = 5000000,
              -- Include blade files so intelephense indexes them
              associations = { "*.php", "*.blade.php" }
            },
            -- These stubs give you Laravel facade autocompletion (free tier)
            stubs = {
              "apache", "bcmath", "bz2", "calendar", "Core", "ctype",
              "curl", "date", "dom", "exif", "fileinfo", "filter",
              "ftp", "gd", "gettext", "gmp", "hash", "iconv", "imap",
              "intl", "json", "ldap", "libxml", "mbstring", "meta",
              "mysqli", "openssl", "pcntl", "pcre", "PDO", "pdo_mysql",
              "pdo_pgsql", "pdo_sqlite", "Phar", "posix", "readline",
              "Reflection", "session", "SimpleXML", "soap", "sockets",
              "sodium", "SPL", "sqlite3", "standard", "superglobals",
              "tokenizer", "xml", "xmlreader", "xmlwriter", "xsl",
              "zip", "zlib",
              "laravel",    -- keep if needed
            },
            diagnostics = {
              enable = true,
              -- Suppress some noisy Laravel-specific false positives
              undefinedTypes = true,
              undefinedFunctions = false,  -- facades trigger this
              undefinedConstants = false,
              undefinedClassConstants = true,
              undefinedMethods = true,
              undefinedProperties = true,
              undefinedVariables = true,
            },
            completion = {
              insertUseDeclaration = true,       -- auto-add use statements
              fullyQualifyGlobalConstantsAndFunctions = false,
              triggerParameterHints = true,
              maxItems = 100,
            },
            format = {
              enable = false  -- we'll use php-cs-fixer instead
            }
          }
        }
      })
      lspconfig.phpactor.setup({
        capabilities = capabilities,
        filetypes = { "php" },
        init_options = {
          ["language_server_phpstan.enabled"] = false,
          ["language_server_psalm.enabled"] = false,
          ["language_server_completion.enabled"] = false, 
          ["language_server_hover.enabled"] = false,
          ["language_server_diagnostics.enabled"] = false,
          ["language_server_worse_reflection_diagnostics.enabled"] = false,
        }
      })

      lspconfig.jdtls.setup { capabilities = capabilities}  -- Optional, nvim-jdtls overrides this
      lspconfig.vtsls.setup { capabilities = capabilities}
    end
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
  }
}
