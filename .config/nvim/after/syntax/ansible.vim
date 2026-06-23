" ansible-vim keeps this flag across :edit, causing YAML syntax not to reload.
unlet! b:yaml_syntax_loaded
