return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      log_level = "error",
      suppressed_dirs = { "~/", "~/Projects", "/" },

      -- auto_save_enabled is true by default, no need to set it

      pre_save_cmds = {
        function(session_name)
          -- session_name is something like "%home%user%myproject.vim"
          -- derive the full path and check if it already exists
          local root = vim.fn.stdpath("data") .. "/sessions/"
          local session_file = root .. session_name

          if vim.fn.filereadable(session_file) == 0 then
            return false  -- no existing session → block auto-save
          end
          -- file exists → allow save
        end,
      },
    })
    require("telescope").load_extension("session-lens")
  end,
}
