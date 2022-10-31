local wezterm = require 'wezterm';

wezterm.on('update-right-status', function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {}

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find '/'
    local cwd = ''
    local hostname = ''
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find '[.]'
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      -- and extract the cwd from the uri
      cwd = cwd_uri:sub(slash)

      table.insert(cells, cwd)
      table.insert(cells, hostname)
    end
  end

  -- I like my date/time in this style: "Wed Mar 3 08:14"
  -- local date = wezterm.strftime '%a %b %-d %H:%M'
  -- table.insert(cells, date)

  -- An entry for each battery (typically 0 or 1 battery)
  -- for _, b in ipairs(wezterm.battery_info()) do
  --   table.insert(cells, string.format('%.0f%%', b.state_of_charge * 100))
  -- end

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3)
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the backgrounds of each cell
  local colors = {
    '#3c1361',
    '#52307c',
    '#663a82',
    '#7c5295',
    '#b491c8',
  }

  -- Foreground color for the text across the fade
  local text_fg = '#c0c0c0'

  -- The elements to be formatted
  local elements = {}
  -- How many cells have been formatted
  local num_cells = 0

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, { Foreground = { Color = text_fg } })
    table.insert(elements, { Background = { Color = colors[cell_no] } })
    table.insert(elements, { Text = ' ' .. text .. ' ' })
    if not is_last then
      table.insert(elements, { Foreground = { Color = colors[cell_no + 1] } })
      table.insert(elements, { Text = SOLID_LEFT_ARROW })
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements))
end)

wezterm.on('toggle-ligature', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.harfbuzz_features then
    -- If we haven't overridden it yet, then override with ligatures disabled
    overrides.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
  else
    -- else we did already, and we should disable out override now
    overrides.harfbuzz_features = nil
  end
  window:set_config_overrides(overrides)
end)

return {

  color_scheme = "Solarized Dark - Patched",
  -- color_scheme = "Solarized Darcula",
  -- color_scheme = "Solarized Dark Higher Contrast",

  font_size = 16.0,

  -- solid blinking cursor (no ease in/out)
  default_cursor_style = 'BlinkingBlock',
  cursor_blink_ease_in = 'Constant',
  cursor_blink_ease_out = 'Constant',
  cursor_blink_rate = 500,

  enable_scroll_bar = true,

  window_padding = { left = 0, right = 0, top = 0, bottom = 0, },

  -- not working ?
  use_dead_keys = false,
  -- prevent ligatures such as != or >=
  -- harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' },

  inactive_pane_hsb = {
      hue = 1.0,
      saturation = 0.7,
      brightness = 0.8,
  },

  hyperlink_rules = {
    -- Linkify things that look like URLs and the host has a TLD name.
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = '\\b\\w+://[\\w.-]+\\.[a-z]{2,15}\\S*\\b',
      format = '$0',
    },
    -- linkify email addresses
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\b\w+@[\w-]+(\.[\w-]+)+\b]],
      format = 'mailto:$0',
    },

    -- file:// URI
    -- Compiled-in default. Used if you don't specify any hyperlink_rules.
    {
      regex = [[\bfile://\S*\b]],
      format = '$0',
    },

    -- Linkify things that look like URLs with numeric addresses as hosts.
    -- E.g. http://127.0.0.1:8000 for a local development server,
    -- or http://192.168.1.1 for the web interface of many routers.
    {
      regex = [[\b\w+://(?:[\d]{1,3}\.){3}[\d]{1,3}\S*\b]],
      format = '$0',
    },
  },
  launch_menu = {
    {
      args = { 'top' },
    },
    {
      label = 'sys M&R',
      args = {'ssh','sys.moveandrent.com'},
    }
  },
  mouse_bindings = {
    -- Default behavior is to follow open links. Disable, just select text.
    {event={Up={streak=1, button="Left"}}, mods="NONE", action=wezterm.action.CompleteSelection("PrimarySelection")},
    -- and make CTRL-Click open hyperlinks (even when mouse reporting)
    {event={Up={streak=1, button="Left"}}, mods="CTRL", action="OpenLinkAtMouseCursor", mouse_reporting=true},
    {event={Up={streak=1, button="Left"}}, mods="CTRL", action="OpenLinkAtMouseCursor"},
    -- Since we capture the 'Up' event, Disable 'Down' of ctrl-click to avoid programs from receiving it
    {event={Down={streak=1, button="Left"}}, mods="CTRL", action="Nop", mouse_reporting=true},
    -- allow selecting cmd output with quadruple-click
    {
      event = { Down = { streak = 4, button = 'Left' } },
      action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
      mods = 'NONE',
    },

  },

  leader = { key="@", mods="CTRL" },
  keys = {
    { key = 'UpArrow',   mods = 'SHIFT',      action = wezterm.action.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'SHIFT',      action = wezterm.action.ScrollToPrompt(1) },
    { key = 'k',         mods = 'CTRL|SHIFT', action = wezterm.action.ClearScrollback("ScrollbackAndViewport")},

    { key = 'l',         mods = 'LEADER',     action = wezterm.action.EmitEvent 'toggle-ligature' },
  },
  colors = {
    -- The color of the scrollbar "thumb"; the portion that represents the current viewport
    scrollbar_thumb = '#888888',
    selection_bg    = '#555555',
  },
}
