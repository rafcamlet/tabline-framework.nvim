local function get_tab_var(tab, name)
  local has_name, tab_var = pcall(vim.api.nvim_tabpage_get_var, tab, name)
  return has_name and tab_var
end

local function print_warn(str)
  vim.api.nvim_command('echohl WarningMsg')
  vim.api.nvim_command(('echomsg "%s"'):format(str))
  vim.api.nvim_command('echohl None')
end

local function print_error(str)
  vim.api.nvim_command('echohl Error')
  vim.api.nvim_command(('echomsg "%s"'):format(str))
  vim.api.nvim_command('echohl None')
end

return {
  get_tab_var = get_tab_var,
  print_warn = print_warn,
  print_error = print_error,
}
