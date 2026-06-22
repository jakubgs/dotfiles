-- Get absolute path of root of current Git repo
function _G.GetGitRoot()
  local root = vim.fn.split(vim.fn.system("git rev-parse --show-toplevel"), "\n")[1]
  return vim.v.shell_error ~= 0 and "" or root
end

-- Copy file path to clipboard
function _G.CopyPath(relative)
  local path = vim.fn.expand("%:p")
  if relative then
    path = vim.fn.substitute(path, _G.GetGitRoot() .. "/", "", "")
  end
  print("Copying: " .. path)
  vim.fn.setreg("*", path)
  vim.fn.setreg("+", path)
end
