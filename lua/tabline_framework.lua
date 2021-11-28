local print_warn = require'tabline_framework.helpers'.print_warn
local hi = require'tabline_framework.highlights'
local Config = require'tabline_framework.config'
local Tabline = require'tabline_framework.tabline'

local function make_tabline()
  return Tabline.run(Config.render)
end

local function setup(opts)
  opts = opts or {}

  if not opts.render then
    print_warn 'TablineFramework: Render function not defined'
    return
  end

  hi.clear()

  Config:new {
    hl = hi.tabline(),
    hl_sel = hi.tabline_sel(),
    hl_fill = hi.tabline_fill()
  }

  Config:merge(opts)

  vim.opt.tabline = [[%!v:lua.require'tabline_framework'.make_tabline()]]
end

return {
  make_tabline = make_tabline,
  setup = setup
}
