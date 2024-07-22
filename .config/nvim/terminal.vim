" Terminal toggling
lua << EOF
require("toggleterm").setup{
  open_mapping = [[<c-\>]],
  start_in_insert = true,
  insert_mappings = true,
  close_on_exit = true,
  autochdir = false,
  direction = 'float',
  float_opts = {
    border = 'curved',
    width = 150,
    height = 50,
  },
  on_open = function(term)
    git_root = vim.api.nvim_call_function("GetGitRoot", {})
    term:send("cd " .. git_root .. "; clear")
  end,
}
EOF
