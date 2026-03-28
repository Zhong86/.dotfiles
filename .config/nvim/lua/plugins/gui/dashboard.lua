numberOfPrj = 3;

local function create_new_file()
  vim.ui.input({ prompt = "Enter filename: " }, function(input)
    if input and input ~= "" then
      vim.cmd("edit " .. input)
    end
  end)
end

return {
  'nvimdev/dashboard-nvim',
  event = 'VimEnter',
  config = function()
    vim.api.nvim_set_hl(0, "DashboardFooter", { fg = "#FF8C00" })  -- Dark orange hex
    local logo = [[
 ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
 ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ 
▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
   ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   
         ░    ░  ░    ░ ░        ░   ░         ░   
    ]]

    logo = string.rep("\n", 1) .. logo .. ""
    require('dashboard').setup {
      config = {
        header = vim.split(logo, "\n"),
        disable_move= true,
        shortcut = {
          {
            desc = '󰊳 Update',
            group = '@property',
            action = 'Lazy update',
            key = 'u'
          },
          {
            desc = ' Files',
            group = 'Label',
            action = 'Telescope find_files',
            key = 'f',
          },
          {
            desc = '󱚌 New',
            group = 'Number',
            key = 'e',
            action = create_new_file
          },
          {
            desc = ' Colorscheme',
            group = 'DiagnosticHint',
            key = 'c',
            action = 'Telescope colorscheme'
          }
        },
        project = {limit = numberOfPrj-1},
        mru = { enable = false },
        footer = {
          "󰈸 Don't You Dare Go Hollow"
        }
      }
    }

    -- open dashboard after closing lazy
    if vim.o.filetype == "lazy" then
      vim.api.nvim_create_autocmd("WinClosed", {
        pattern = tostring(vim.api.nvim_get_current_win()),
        once = true,
        callback = function()
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("UIEnter", { group = "dashboard" })
          end)
        end,
      })
    end
  end,

  dependencies = { {'nvim-tree/nvim-web-devicons'}}
}
