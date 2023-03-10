<h1 align="center">tabline-framework.nvim</h1>
<p align="center"><b>User-friendly framework for building your dream tabline in a few lines of code.</b></p>

Do you know the lua basics and nothing about tablines? Or maybe are you just lazy and don't want to write all the necessary code before fun part? Do you prefer vim tabs or buffer-lines? Or maybe you hate both and just wanted an extra status line? You know what? This plugin is just for you.

## Demo

![image](https://user-images.githubusercontent.com/8767998/143782627-534f32b3-7b40-457d-86bf-0a42369d78da.png)

```lua
local render = function(f)
  f.add '   '

  f.make_tabs(function(info)
    f.add(' ' .. info.index .. ' ')
    f.add(info.filename or '[no name]')
    f.add(info.modified and '+')
    f.add ' '
  end)
end
```

[Check other examples!](#examples)

----
- [Installation](#installation)
- [Configuration](#configuration)
- [How to use it](#how-to-use-it)
- [Examples](#examples)
- [Docs](#docs)
----

## Installation

With packer.nvim:

```lua
use { "rafcamlet/tabline-framework.nvim",  requires = "kyazdani42/nvim-web-devicons" }
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
  hl_sel = { fg = "#282c34" bg ="#abb2bf" gui = "bold,underline" }
  -- Default color of everything except items
  -- if not set TF uses TabLineFill highlight group colors
  hl_fill = { fg = "#282c34" bg ="#abb2bf" }
}

```

## How to use it

The render function is a heart of TablineFramework. The whole tabline is defined inside it. It takes a single argument, which contains a table of functions required to manipulating the final result. Let's look at a simple example:

```lua
local render = function(f)
  f.add { ' ', fg = "#bb0000" }
  f.add ' '
end

require('tabline_framework').setup { render = render }
```

![image](https://user-images.githubusercontent.com/8767998/143783565-b7ded55b-f91c-424f-9520-1fc1203bd0c2.png)

`add` function can take a string or a table as its argument. The first item in table is a content which will be added to tabline. Using the `fg`, `bg` keys, you can specify its highlighting.

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
![image](https://user-images.githubusercontent.com/8767998/143783645-a5f43c2c-9ba2-4418-8eda-700b5ac82c6a.png)


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
![image](https://user-images.githubusercontent.com/8767998/143783694-1733e1f7-4cec-4487-ab29-fd6e30ab24bb.png)

Icons? People love icons!

```lua
local render = function(f)
  f.add { '   ', fg = "#bb0000" }

  f.make_tabs(function(info)
    -- With the help of kyazdani42/nvim-web-devicons we can fetch color
    -- associated with the filetype
    local icon_color = f.icon_color(info.filename)

    -- If this is the current tab then highlight it
    if info.current then
      -- We can use set_fg to change default fg color
      -- so you won't need to specify it every time
      f.set_fg(icon_color)
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
![image](https://user-images.githubusercontent.com/8767998/143783741-1bf0688d-5b8b-45ac-92c4-5649d9320f4a.png)


The right side looks a bit blank. Maybe lsp diagnostic indicators?

```lua
local render = function(f)
  f.add { '   ', fg = "#bb0000" }

  f.make_tabs(function(info)
    -- ...
  end)

  -- Let's add a spacer wich will justify the rest of the tabline to the right
  f.add_spacer()

  -- get some info from lsp
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  -- and display it
  f.add { '  ' .. errors, fg = "#e86671" }
  f.add { '  ' .. warnings, fg = "#e5c07b"}
  f.add ' '
end
```
![image](https://user-images.githubusercontent.com/8767998/143783814-45fd2171-ac07-42c3-b231-bc2da785b9b5.png)

## Examples


<details>
  <summary><b>simple</b></summary>

```lua
-- Try it:
require('tabline_framework').setup {
  render = require('tabline_framework.examples.simple'),
}

```
```lua
local render = function(f)
  f.add '   '

  f.make_tabs(function(info)
    f.add(' ' .. info.index .. ' ')
    f.add(info.filename or '[no name]')
    f.add(info.modified and '+')
    f.add ' '
  end)
end
```

</details>

![image](https://user-images.githubusercontent.com/8767998/143782627-534f32b3-7b40-457d-86bf-0a42369d78da.png)

<details>
  <summary><b>diagonal_tiles</b></summary>

```lua
-- Try it:
require('tabline_framework').setup {
  render = require('tabline_framework.examples.diagonal_tiles'),
  hl = { fg = '#abb2bf', bg = '#181A1F' },
  hl_sel = { fg = '#abb2bf', bg = '#282c34'},
  hl_fill = { fg = '#ffffff', bg = '#000000'},
}

```
```lua
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
```
</details>

![image](https://user-images.githubusercontent.com/8767998/143783288-978394c5-09b9-42ee-a406-54b111d7b828.png)


<details>
  <summary><b>fancy_indexes</b></summary>

```lua
-- Try it:
require('tabline_framework').setup {
  render = require('tabline_framework.examples.fancy_indexes'),
  hl = { fg = '#abb2bf', bg = '#181A1F' },
  hl_sel = { fg = '#abb2bf', bg = '#282c34'},
  hl_fill = { fg = '#ffffff', bg = '#000000'},
}
```
```lua
local inactive = {
  black = '#000000',
  white = '#ffffff',
  fg = '#696969',
  bg_1 = '#181A1F',
  bg_2 = '#202728',
  index = '#61afef',
}

local active = vim.tbl_extend('force', inactive, {
  fg = '#abb2bf',
  bg_2 = '#282c34',
  index = '#d19a66',
})

local render = function(f)
  f.add '  '
  f.make_tabs(function(info)
    local colors = info.current and active or inactive

    f.add {
      ' ' .. info.index .. ' ',
      fg = colors.index,
      bg = colors.bg_1
    }

    f.set_colors { fg = colors.fg, bg = colors.bg_2 }

    f.add ' '
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
    f.add ' '
    f.add { ' ', bg = colors.black }
  end)

  f.add_spacer()

  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  f.add { '  ' .. errors, fg = "#e86671" }
  f.add { '  ' .. warnings, fg = "#e5c07b"}
  f.add ' '
end
```
</details>

![image](https://user-images.githubusercontent.com/8767998/143783435-02b122f9-3873-4873-9939-c3717daffb60.png)

<details>
  <summary><b>tabs_and_buffers</b></summary>

WARNING: The current implementation of the buff grouping mechanism is not good enough for real usage and is for presentation purposes only.
```lua
-- Try it:
require('tabline_framework').setup {
  render = require('tabline_framework.examples.tabs_and_buffers'),
}
```
```lua
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
```
</details>

![image](https://user-images.githubusercontent.com/8767998/143783076-83a967a3-a56e-4ae8-b32f-07f29b633fc0.png)

## Docs

### `f.add()`
* `f.add 'string'`
* `f.add { 'string', fg = '#ffffff', bg = '#000000' }`

Adds `string` to the tabline and optionally sets its highlighting.

### `f.set_fg('#ffffff')`
Sets the default foreground color. Useful for changing highlight of many elements. Calling `make_tabs` or` make_bufs` resets the default colors, same as each tab/bufs item iteration.

### `f.set_bg('#000000')`
Same as `set_fg`, but background.

### `f.set_gui('bold,underline')`
Same as `set_fg`, but for gui options.

### `f.set_colors { fg = '#ffffff', bg = '#000000', gui = 'italic' }`
Sets default colors

### `f.add_spacer()`
Add separation point between alignment sections. Add one to split line into left and right, use two to add centre.

### `f.icon('filename.lua')`
Returns the icon associated with filetype based on the passed filename.

### `f.icon_color('filename.lua')`
Returns the color associated with filetype based on the passed filename.

### `f.make_tabs()`
* `f.make_tabs(callback)`
* `f.make_tabs(callback, tablist)`

It iterates over all tabs and passes to its callback table with tab related info. Optionally takes a second argument with a list of tab IDs, allowing you to specify custom ordering or filtering.


* `info.index` - tab index
* `info.tab` - tab id
* `info.win` - id of the focused window inside the tab
* `info.buf` - id of the buffer displayed in the focused window inside the tab
* `info.buf_name` - buffer name
* `info.filename` - filename extracted from buffer name or nil when `buf_name` is empty
* `info.modified` - boolean: indicates if the buffer has been modified
* `info.current` - boolean: indicates if the buffer is focused
* `info.before_current` - boolean: indicates if the next buffer is the focused one. Might be useful for conditionally adding item separators.
* `info.after_current` - boolean: indicates if the previous buffer was the focused one.
* `info.first` - boolean: indicates if tab is first in list
* `info.last` - boolean: indicates if tab is last in list

### `f.make_bufs()`
* `f.make_bufs(callback)`
* `f.make_bufs(callback, buflist)`

Like `make_tabs` but iterates over listed buffers (check the `:h buflisted`). The info table has no `win` and `tab` keys, because buffers can be associated with multiple (or none) windows/tabs.

### `f.close_tab_btn()`
* `f.close_tab_btn 'string'`
* `f.close_tab_btn { 'string', fg = '#ffffff', bg = '#000000', gui = 'bold,underline' }`

Adds a native close button to the tab. Calling this function outside of `make_tabs` gives a warning and does nothing.

----

**Do you have questions? An idea for missing functionalities? Found a bug? Don't be afraid to open a new issue.**
