--Base Java file
vim.api.nvim_create_user_command("Java", function(opts)
  local class_name = opts.args
  if class_name == "" then
    print("Usage: :Java ClassName")
    return
  end

  local filename = class_name .. ".java"
  local filepath = vim.fn.expand("%:p:h") .. "/" .. filename  -- creates in current file's directory

  local lines = {
    "public class " .. class_name .. " {",
    "",
    "    public static void main(String[] args) {",
    "    }",
    "",
    "}",
  }

  -- Write and open the file
  vim.fn.writefile(lines, filepath)
  vim.cmd("edit " .. filepath)
  vim.cmd("normal! 2G$")  -- move cursor to line 2
end, { nargs = 1 })

--Springboot file
vim.api.nvim_create_user_command("Springboot", function(opts)
  local class_name = opts.args
  if class_name == "" then
    print("Usage: :Springboot ClassName")
    return
  end

  local current_dir = vim.fn.expand("%:p:h")
  local new_dir = current_dir .. "/" .. class_name
  vim.fn.mkdir(new_dir, "p")

  local filename = class_name .. ".java"
  local filepath = new_dir .. "/" .. filename  

  -- Basic Java template
  local lines = {
    "public class " .. class_name .. " {",
    "",
    "}",
  }

  -- Write and open the file
  vim.fn.writefile(lines, filepath)
  vim.cmd("edit " .. filepath)
  vim.cmd("normal! 2G$")  -- move cursor to line 2
end, { nargs = 1 })
