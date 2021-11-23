local config = {}
local highlights = {}
local get_icon = require'nvim-web-devicons'.get_icon

-- TabLine		tab pages line, not active tab page label
-- TabLineFill	tab pages line, where there are no labels
-- TabLineSel	tab pages line, active tab page label

local function hl_color(group, fg, bg, gui)
  local cmd = ('highlight %s guifg=%s guibg=%s gui=%s'):format(
    group,
    fg or 'NONE',
    bg or 'NONE',
    gui or 'NONE'
  )
  vim.api.nvim_command(cmd)
  return group
end

local function get_hl(color)
  local c = vim.api.nvim_get_hl_by_name(color, true)
  return {
    fg = c.foreground and string.format('#%06x', c.foreground),
    bg = c.background and string.format('#%06x', c.background),
  }
end

local function icon(name, colors)
  colors = colors or {}
  -- TODO: dodać rozróżnienie
  local i, hl = get_icon(name)
  if hl == 'DevIconDefault' then return '' end

  local devicons_color = get_hl(hl)
  local color = hl_color('RealTabline' .. hl, devicons_color.fg, colors.bg)

  return ('%%#%s#%s'):format(color, i)
end

config.render = function(opts)
  local name = #opts.name > 0 and opts.name or '[No Name]'

  return table.concat({
    opts.index,
    name,
    icon(name)
  }, ' ')
end

local function tabline()
  local line = ''

  for i, v in ipairs(vim.api.nvim_list_tabpages()) do
    local current = vim.api.nvim_get_current_tabpage() == v
    local win = vim.api.nvim_tabpage_get_win(v)
    local buf = vim.api.nvim_win_get_buf(win)
    local full_name = vim.api.nvim_buf_get_name(buf)
    local name = vim.fn.fnamemodify(full_name, ":t")
    local modified = vim.api.nvim_buf_get_option(buf, 'modified')

    line = line .. config.render({
      index = i,
      current = current,
      buffer = vim.fn.bufnr(i),
      win = win,
      buf = buf,
      full_name = full_name,
      name = name,
      modified = modified
    })
  end

  -- TODO: make this configurable
  line = '%#RealTabline#' .. line .. '%#RealTabline#%='

  return line
end

local function setup(opts)
  opts = opts or {}
  vim.tbl_extend('force', config, opts)

  -- if opts.hl then
  --   hl_color('TabLine', opts.hl.fg, opts.hl.bg)
  --   hl_color('TabLineFill', opts.hl.fg, opts.hl.bg)
  -- end

  hl_color('RealTabline', '#ffffff', '#000000')

  vim.opt.tabline = [[%!v:lua.require'real_tabline'.tabline()]]
end

return {
  tabline = tabline,
  setup = setup
}
