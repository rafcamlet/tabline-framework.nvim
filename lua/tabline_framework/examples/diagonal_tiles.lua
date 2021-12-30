-- Author: Rafał Camlet
--
-- require('tabline_framework').setup {
--   render = require('tabline_framework.examples.diagonal_tiles'),
--   hl = { fg = '#abb2bf', bg = '#181A1F' },
--   hl_sel = { fg = '#abb2bf', bg = '#282c34'},
--   hl_fill = { fg = '#ffffff', bg = '#000000'},
-- }

local colors = {
  black = '#000000',
  white = '#ffffff',
  bg = '#181A1F',
  bg_sel = '#282c34',
  fg = '#696969'
}

local render = function(f)
  f.add { '  ' }

  f.make_tabs(function(info)
    f.add {  ' ', fg = colors.black }
    f.set_fg(not info.current and colors.fg or nil)

    f.add( info.index .. ' ')

    if info.filename then
      f.add(info.modified and '+')
      f.add(info.filename)
      f.add {
        ' ' .. f.icon(info.filename),
        fg = info.current and f.icon_color(info.filename) or nil
      }
    else
      f.add(info.modified and '[+]' or '[-]')
    end

    f.add {
      ' ',
      fg = info.current and colors.bg_sel or colors.bg,
      bg = colors.black
    }
  end)

  f.add_spacer()

  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  f.add { '  ' .. errors, fg = "#e86671" }
  f.add { '  ' .. warnings, fg = "#e5c07b"}
  f.add ' '
end

return render
