
local Modules = {}

--Centering box
local function center(outer, inner)
  return (outer - inner) / 2
end

local function expandPath(path)
  if path:sub(1,1) == "~" then
    return os.getenv("HOME") .. path:sub(2)
  end
  return path
end

local function winConfig()
  local width = math.min(math.floor(vim.o.columns * 0.8), 64)
  local height = math.floor(vim.o.lines * 0.8)

  return {
    relative = "editor",
    width = width,
    height = height,
    col = center(vim.o.columns, width),
    row = center(vim.o.lines, height),
    border = "single"
  }
end

local function openFloatingFile(targetFile)
  local expandedPath = expandPath(targetFile)

  if vim.fn.filereadable(expandedPath) == 0 then
    vim.notify("Todo file does not exist at directory: " .. expandedPath, vim.log.levels.ERROR)
    return
  end

  local buf = vim.fn.bufnr(expandedPath, true)

  if buf == -1 then
    buf = vim.api.nvim_create_buf(false, false)
    vim.api.nvim_buf_set_name(buf, expandedPath)
  end

  vim.bo[buf].swapfile = false

  local win = vim.api.nvim_open_win(buf, true, winConfig())

  vim.api.nvim_buf_set_keymap(buf, "n", "q", "", {
    noremap  = true,
    silent = true,
    callback = function()
      vim.cmd("w")
      vim.api.nvim_win_close(0, true)
    end
  })

end

local function setup_user_commands(opts)
  local targetFile = opts.targetFile or "todo.md"
  vim.api.nvim_create_user_command("Todo", function()
    openFloatingFile(targetFile)
  end, {})

end

Modules.setup = function(opts)
  setup_user_commands(opts)
end


return Modules
