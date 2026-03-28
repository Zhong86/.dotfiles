return {
  -- Blade syntax highlighting via treesitter custom parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- Append blade to existing ensure_installed
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "php_only" })
      end
    end,
  },

  -- Blade-specific treesitter grammar (install with :TSInstall blade)
  {
    "EmranMR/tree-sitter-blade",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }

      -- Make Neovim recognize .blade.php as blade filetype
      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })
    end
  },
}
