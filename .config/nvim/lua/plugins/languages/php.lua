return {
  -- Formatter (php-cs-fixer, blade-formatter)
  {
    "stevearc/conform.nvim",
    cmd = { "ConformInfo" },
    keys = { "<leader>r" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          php = { "php_cs_fixer" },
          blade = { "blade_formatter" },
        },
        formatters = {
          php_cs_fixer = {
            -- Uses .php-cs-fixer.php in project root if it exists
            command = "php-cs-fixer",
            args = { "fix", "--using-cache=no", "--quiet", "$FILENAME" },
            stdin = false,
          },
          blade_formatter = {
            command = "blade-formatter",
            args = { "--write", "$FILENAME" },
            stdin = false,
          }
        }
      })

      -- Manual format keymap
      vim.keymap.set({ "n", "v" }, "<leader>r", function()
        require("conform").format({ async = true, lsp_fallback = false })
      end, { desc = "Format file" })
    end
  },

  -- Linter (phpstan for static analysis)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        php = { "phpstan" },
      }

      -- Configure phpstan to use your project's phpstan.neon
      lint.linters.phpstan.args = {
        "analyse",
        "--error-format=json",
        "--no-progress",
        -- Uses phpstan.neon in project root automatically
      }

      -- Run linting on save and file open
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          local ft = vim.bo.filetype
          if ft == "php" then
            lint.try_lint()
          end
        end,
      })

      vim.keymap.set("n", "<leader>cl", function()
        lint.try_lint()
      end, { desc = "Trigger linting" })
    end
  },
}
