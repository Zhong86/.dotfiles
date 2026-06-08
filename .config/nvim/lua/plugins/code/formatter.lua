return {
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },

    keys = {
      {
        "<leader>r",
        function()
          require("conform").format({
            async = true,
            lsp_fallback = true,
          })
        end,
        desc = "Format file",
      },
    },

    opts = {
      formatters_by_ft = {
        php = { "php_cs_fixer" },
        blade = { "blade_formatter" },

        javascript = { "prettier" },
        javascriptreact = { "prettier" },

        typescript = { "prettier" },
        typescriptreact = { "prettier" },

        json = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        markdown = { "prettier" },

        lua = { "stylua" },
      },

      formatters = {
        php_cs_fixer = {
          command = "php-cs-fixer",
          args = {
            "fix",
            "--using-cache=no",
            "--quiet",
            "$FILENAME",
          },
          stdin = false,
        },

        blade_formatter = {
          command = "blade-formatter",
          args = {
            "--write",
            "$FILENAME",
          },
          stdin = false,
        },
      },
    },
  },
}
