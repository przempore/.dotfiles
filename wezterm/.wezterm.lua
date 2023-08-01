-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Batman'

-- config.colors = {}
-- config.colors.background = '#111111'
config.color_scheme = 'Catppuccin Mocha'
config.window_background_opacity = 0.95

-- config.font = wezterm.font_with_fallback {
--   'JetBrainsMono Nerd Font Mono',
--   'nonicons',
-- }

config.leader = { key="a", mods="CTRL", timeout_milliseconds=1000 }
config.keys = {
  {
    key = '|',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitHorizontal{domain="CurrentPaneDomain"},
  },
  {
    key = '_',
    mods = 'LEADER|SHIFT',
    action = wezterm.action.SplitVertical{domain="CurrentPaneDomain"},
  },
  {
    key = 'h',
    mods = 'SHIFT|CTRL',
    action = wezterm.action.ActivateCopyMode,
  },
}

-- default is true, has more "native" look
config.use_fancy_tab_bar = false

-- I don't like putting anything at the ege if I can help it.
config.enable_scroll_bar = false
config.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}

config.tab_bar_at_bottom = true
config.freetype_load_target = "HorizontalLcd"

-- and finally, return the configuration to wezterm
return config
