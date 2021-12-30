-- Author: Rafał Camlet
--
-- require('tabline_framework').setup {
--   render = require('tabline_framework.examples.from_readme'),
--   hl = { fg = '#abb2bf', bg = '#181A1F' },
--   hl_sel = { fg = '#abb2bf', bg = '#282c34'},
--   hl_fill = { fg = '#ffffff', bg = '#000000'},
-- }

local render = function(f)
  f.add { '   ', fg = "#bb0000" }

  f.make_tabs(function(info)
    if info.current then
      f.set_fg(f.icon_color(info.filename))
    end

    f.add( ' ' .. info.index .. ' ')

    if info.filename then
      f.add(info.modified and '+')
      f.add(info.filename)

      f.add(' ' .. f.icon(info.filename))
    else
      f.add(info.modified and '[+]' or '[-]')
    end
    f.add ' '
  end)

  f.add_spacer()

  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  f.add { '  ' .. errors, fg = "#e86671" }
  f.add { '  ' .. warnings, fg = "#e5c07b"}
  f.add ' '
end

return render
