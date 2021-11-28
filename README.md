<h1 align="center">tabline-framework.nvim</h1>
<p align="center"><b>User-friendly framework for building your dream tabline in a few lines of code.</b></p>

Do you know the lua basics and nothing about tablines? Or maybe are you just lazy and don't want to write all the necessary code before fun part? Do you prefer vim tabs or buffer-lines? Or maybe you hate both and just wanted an extra status line? You know what? This plugin is just for you.

## Demo

## Installation

With vim-plug:

```
    Plug "rafcamlet/tabline-framework.nvim"
```

## Configuration

```lua
require('tabline_framework').setup {
  -- Render function is resposible for generating content of tabline
  -- This is the place where you do your magic!
  render = function(f)
    f.add 'This is my tabline!'
  end,
  -- Default color of tabline items: tabs/bufs
  -- if not set TF uses TabLine highlight group colors
  hl = { fg = "#abb2bf" bg ="#31353f" }
  -- Default color of selected item
  -- if not set TF uses TabLineSel highlight group colors
  hl_sel = { fg = "#282c34" bg ="#abb2bf" }
  -- Default color of everything except items
  -- if not set TF uses TabLineFill highlight group colors
  hl_fill = { fg = "#282c34" bg ="#abb2bf" }
}

```

## How to use it?

The render function is a heart of TablineFramework. The whole tabline is defined inside it. It takes a single argument, which contains a table of functions required to manipulating the final result. Let's look at a simple example:

```lua
local render = function(f)
  f.add { ' ', fg = "#bb0000" }
  f.add ' '
end

require('tabline_framework').setup { render = render }
```

`add` function can take a string or a table as its argument. The first argument of table is a content which will be added to tabline. Using the `fg`, `bg` keys, you can specify its color.

Okay, so we have a fancy bug icon, but that isn't too useful. Let's add tabs to it!

```lua
local render = function(f)
  f.add { '   ', fg = "#bb0000" }

  f.make_tabs(function(info)
    f.add(' ' .. info.index .. ' ')
    f.add(info.filename or '[no name]')
    f.add ' '
  end)
end
```

The `make_tabs` function takes callback which will be called for each existing tab. As argument it provides table with tab-related information, which you can use in item content. In the example above, we used index number and the filename of focused buffer.

Don't you like tabs? Just replace `make_tabs` with `make_bufs`. Simple as that.

Do you want something more fancy?

```lua
local render = function(f)
  f.add { '   ', fg = "#bb0000" }

  f.make_tabs(function(info)
    f.add( ' ' .. info.index .. ' ')

    if info.filename then
      -- let's add + sign if the buffer is modified
      f.add(info.modified and '+')
      f.add(info.filename)
    else
      -- Why waste space for [no name] ?
      -- Let's use [-] if the buffer has no name
      -- or [+] if it is also modified
      f.add(info.modified and '[+]' or '[-]')
    end

    f.add ' '
  end)
end
```

Icons? People love icons!

```lua
local render = function(f)
  f.add { '   ', fg = "#bb0000" }

  f.make_tabs(function(info)
    -- With the help of kyazdani42/nvim-web-devicons we can fetch color
    -- associated with the filetype
    local icon_color = f.icon_color(info.filename)

    -- If this is the current tab then hilight it
    if info.current then
      -- We can use set_fg to change default fg color
      -- so you won't need to specify it every time
      f.set_fg(f.icon_color(info.filename))
    end

    f.add( ' ' .. info.index .. ' ')

    if info.filename then
      f.add(info.modified and '+')
      f.add(info.filename)

      -- The icon function returns a filetype icon based on the filename
      f.add(' ' .. f.icon(info.filename))
    else
      f.add(info.modified and '[+]' or '[-]')
    end
    f.add ' '
  end)
end
```

```lua
local render = function(f)
  f.add { '   ', fg = "#bb0000" }

  f.make_tabs(function(info)
    -- ...
  end)

  -- Let's add a spacer wich will justify the rest of the tabline to the right
  f.add_spacer()

  -- get some info from lsp
  local errors = vim.lsp.diagnostic.get_count(0, 'Error')
  local warnings = vim.lsp.diagnostic.get_count(0, 'Warning')

  -- and display it
  f.add { '  ' .. errors, fg = "#e86671" }
  f.add { '  ' .. warnings, fg = "#e5c07b"}
  f.add ' '
end
```

