local colors = {}
local color_index = 0

local function clear()
  colors = {}
  color_index = 0
end

local function set_hl(fg, bg, gui)
  if not fg and not bg and not gui then return end
  local key = fg:sub(2) .. '_' .. bg:sub(2)
  if colors[key] then return colors[key] end

  color_index = color_index + 1
  local group = 'TablineFramework_' .. color_index
  colors[key] = group

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
    fg = c.foreground and string.format('#%06x', c.foreground) or 'NONE',
    bg = c.background and string.format('#%06x', c.background) or 'NONE'
  }
end

local function tabline()
  return get_hl('TabLine')
end

local function tabline_sel()
  return get_hl('TabLineSel')
end

local function tabline_fill()
  return get_hl('TabLineFill')
end

return {
  clear = clear,
  set_hl = set_hl,
  get_hl = get_hl,
  tabline = tabline,
  tabline_sel = tabline_sel,
  tabline_fill = tabline_fill,
}
