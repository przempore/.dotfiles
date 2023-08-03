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

config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font Mono',
  'JetBrainsMono Nerd Font',
}

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

-- config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.freetype_load_target = "HorizontalLcd"

local system_username = os.getenv('USERNAME');
print(system_username);
config.ssh_domains = {
  {
    -- This name identifies the domain
    name = 'localhost',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = 'localhost',
    -- The username to use on the remote host
    username = system_username,
  },
  {
    -- This name identifies the domain
    name = 'Ilum',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = 'Ilum',
    -- The username to use on the remote host
    username = 'przemek',
  },
  {
    -- This name identifies the domain
    name = 'dooku',
    -- The hostname or address to connect to. Will be used to match settings
    -- from your ssh config file
    remote_address = 'dooku',
    -- The username to use on the remote host
    username = 'porebski',
  },
}

-- and finally, return the configuration to wezterm
return config
