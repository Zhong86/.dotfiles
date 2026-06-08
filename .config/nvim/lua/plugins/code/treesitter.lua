local languages = {
  "lua", "php", "blade",
  "html", "css", "javascript", "json", "typescript",
  "python",
  "c", "java",
  "markdown", "markdown_inline",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      -- Recognize *.blade.php files
      vim.filetype.add({
        pattern = {
          [".*%.blade%.php"] = "blade",
        },
      })

      -- Treesitter setup
      require("nvim-treesitter.configs").setup({
        ensure_installed = languages,

        highlight = {
          enable = true,
        },

        indent = {
          enable = true,
        },
      })
    end,
  }
}
