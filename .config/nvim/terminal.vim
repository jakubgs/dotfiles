" Terminal toggling
lua << EOF
require("toggleterm").setup{
  open_mapping = [[<c-\>]],
  start_in_insert = true,
  insert_mappings = true,
  close_on_exit = true,
  autochdir = true,
  direction = 'float',
  float_opts = {
    border = 'curved',
    width = 150,
    height = 50,
  },
  env = {
    NO_DIRENV = "1",
  }
}
EOF
