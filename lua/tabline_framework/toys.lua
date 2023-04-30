local get_tab_var = require("tabline_framework.helpers").get_tab_var

local function setup_tab_buffers()
  vim.cmd [[augroup TablineBuffers]]
  vim.cmd [[autocmd!]]
  vim.cmd [[autocmd BufEnter * lua require'tabline_framework.toys'.add_buf_to_tab()]]
  -- vim.cmd [[autocmd BufUnload * let g:tabline_buffers_bufnr_last = g:tabline_buffers_bufnr]]
  vim.cmd [[augroup END]]
end

local function get_tab_buffers(tab)
  local tbl = get_tab_var(tab or 0, 'tabline_framework_buffer_list')
  if type(tbl) ~= 'table' then return {} end
  return tbl
end

local function add_buf_to_tab()
  local tab = vim.api.nvim_get_current_tabpage()
  local windows = vim.api.nvim_tabpage_list_wins(tab)
  buffers_in_tab = {}
  for _,v in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(v)

    local is_valid = vim.api.nvim_buf_is_valid(buf)
    local is_listed = vim.api.nvim_buf_get_option(buf, 'buflisted')
    if is_valid and is_listed then
      local name = vim.api.nvim_buf_get_name(buf)
      table.insert(buffers_in_tab, name)
    end
  end
  vim.api.nvim_tabpage_set_var(tab, 'tabline_framework_buffer_list', buffers_in_tab)
end


return {
  setup_tab_buffers = setup_tab_buffers,
  get_tab_buffers = get_tab_buffers,
  add_buf_to_tab = add_buf_to_tab
}
