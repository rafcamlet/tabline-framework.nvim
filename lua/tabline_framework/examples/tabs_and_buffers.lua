-- Author: Rafał Camlet
--
-- require('tabline_framework').setup {
--   render = require('tabline_framework.examples.tabs_and_buffers'),
-- }
--
-- WARNING: The current implementation of the buff grouping mechanism is not good enough for real usage and is for presentation purposes only.

local toys = require 'tabline_framework.toys'

toys.setup_tab_buffers()

local render = function(f)
  f.add '  '

  f.make_bufs(function(info)
    f.add(' ' .. info.buf .. ' ')
    f.add(info.filename or '[no name]')
    f.add(info.modified and '+')
    f.add ' '
  end, toys.get_tab_buffers(0))

  f.add_spacer()

  f.make_tabs(function(info)
    f.add(' ' .. info.index .. ' ')
  end)
end

return render
