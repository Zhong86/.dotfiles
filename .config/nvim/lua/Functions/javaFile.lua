--New Java file
vim.api.nvim_create_user_command("Java", function(opts)
  local class_name = opts.args
  if class_name == "" then
    print("Usage: :Java ClassName")
    return
  end

  local current_dir = vim.fn.expand("%:p:h")

  local filename = class_name .. ".java"
  local filepath = current_dir .. "/" .. filename  

  -- Basic Java template
  local lines = {
    "public class " .. class_name .. " {",
    "  public static void main(String[] args) {",
    "    ", 
    "  }",
    "}",
  }

  -- Write and open the file
  vim.fn.writefile(lines, filepath)
  vim.cmd("edit " .. filepath)
  vim.cmd("normal! 3G$")  
end, { nargs = 1 })
