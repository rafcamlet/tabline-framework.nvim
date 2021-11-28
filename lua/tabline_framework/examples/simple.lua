-- Author: Rafał Camlet
--
-- require('tabline_framework').setup {
--   render = require('tabline_framework.examples.simple'),
-- }

local render = function(f)
  f.add '   '

  f.make_tabs(function(info)
    f.add(' ' .. info.index .. ' ')
    f.add(info.filename or '[no name]')
    f.add(info.modified and '+')
    f.add ' '
  end)
end

return render
