vim.api.nvim_create_user_command("Java", function(opts)
  local class_name = opts.args
  if class_name == "" then
    print("Usage: :Java ClassName")
    return
  end

  local filename = class_name .. ".java"
  local filepath = vim.fn.expand("%:p:h") .. "/" .. filename  -- creates in current file's directory

  -- Basic Java template
  local lines = {
    "public class " .. class_name .. " {",
    "",
    "    public " .. class_name .. "() {",
    "    }",
    "",
    "}",
  }

  -- Write and open the file
  vim.fn.writefile(lines, filepath)
  vim.cmd("edit " .. filepath)
  vim.cmd("normal! 2G$")  -- move cursor to line 2
end, { nargs = 1 })
