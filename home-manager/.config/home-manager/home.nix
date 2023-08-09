{ config, pkgs, ... }:

let
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
    sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
  };
in
{
  home.username = "przemek";
  home.homeDirectory = "/home/przemek";

  home.stateVersion = "23.05";

  home = {
    packages = with pkgs; [
      firefox
    ];

    sessionVariables = {
      EDITOR = "nvim";
      SHELL = "fish";
      VISUAL = "nvim";
    };
  };

  home.keyboard = null;

  home.activation.linkDotfiles = config.lib.dag.entryAfter [ "writeBoundary" ]
    ''
    ln -sfn $HOME/.dotfiles/ranger/.config/ranger/rc.conf       $HOME/.config/ranger/rc.conf
    '';

  programs = {
    firefox = {
      enable = true;
      profiles.default = {
        userChrome = ''
          @import "${
            builtins.fetchGit {
              url = "https://github.com/rockofox/firefox-minima";
              ref = "main";
              rev = "1477b2a28091aad4ebba330c539110c311eb8084";
            }
          }/userChrome.css";
        '';
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };

    wezterm = {
      enable = true;

      extraConfig = ''
        -- Pull in the wezterm API
        local wezterm = require 'wezterm'
        local mux = wezterm.mux

        -- This table will hold the configuration.
        local config = {}

        -- In newer versions of wezterm, use the config_builder which will
        -- help provide clearer error messages
        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        -- This is where you actually apply your config choices
        config.set_environment_variables = {
          IS_WEZTERM = "true"
        }

        -- For example, changing the color scheme:
        -- config.color_scheme = 'Batman'

        -- config.colors = {}
        -- config.colors.background = '#111111'
        config.color_scheme = 'Catppuccin Mocha'
        config.window_background_opacity = 0.95

        config.font_size = 10.0
        config.font =
          wezterm.font('JetBrainsMono Nerd Font Mono', { weight = 'Bold', italic = false })

        -- config.font = wezterm.font_with_fallback {
        --   'JetBrainsMono Nerd Font Mono',
        --   'JetBrainsMono Nerd Font',
        --   'Iosevka Nerd Font Mono',
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
          {
            key = 'Enter',
            mods = 'ALT',
            action = wezterm.action.DisableDefaultAssignment,
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
            name = 'Ilum',
            -- The hostname or address to connect to. Will be used to match settings
            -- from your ssh config file
            remote_address = 'Ilum',
            -- The username to use on the remote host
            username = 'przemek',
          },
          {
            name = 'dooku',
            remote_address = 'dooku',
            username = 'porebski',
          },
        }

        local function getHostname()
          local f = io.popen ("/bin/hostnamectl hostname")
          if not f then return 'not found' end
          local hostname = f:read("*a")
          hostname = hostname:gsub("\n", "")
          f:close()
          return hostname
        end

        local function work()
          local hostname = getHostname()
          return hostname == 'dooku'
        end

        local function work_setup(args)
          local project_path = wezterm.home_dir .. '/Projects/sentinel'
          local tab, pane, window = mux.spawn_window {
            cwd = project_path,
            args = args,
          }

          tab:set_title 'sentinel'
          pane:send_text 'tsh_login\n'
          pane:send_text 'vi .\n'
          local tab, pane, window = window:spawn_tab {
            cwd = wezterm.home_dir,
            args = args,
          }
          tab:set_title 'windows'
          pane:send_text 'if test "$(virsh domstate win10)" = "shut off";virsh start win10;sleep 10;end;\n'
          pane:send_text 'ssh windows\n'
          pane:send_text 'setup.bat\r\n'
        end

        local function home_setup(args)
          local tab, pane, window = mux.spawn_window {
            cwd = wezterm.home_dir,
            args = args,
          }
          tab:set_title 'home'
        end

        wezterm.on('gui-startup', function(cmd)
          -- allow `wezterm start -- something` to affect what we spawn
          -- in our initial window
          local args = {}
          if cmd then
            args = cmd.args
          end

          if work() then
            work_setup(args)
          else
            home_setup(args)
          end
        end)


        config.unix_domains = {
          {
            name = 'localhost',
          },
        }

        -- and finally, return the configuration to wezterm
        return config
    '';
    };

    git = {
      enable = true;

      aliases = {
        lg = "log --graph --pretty=format:'%C(auto)%h -%d %s"
          + " %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
        st = "status -sb";
      };

      userEmail = "przempore@gmail.com";
      userName = "Przemek";
    };

    bat = {
      enable = true;
      config = { theme = "catppuccin"; };
      themes = {
        catppuccin = builtins.readFile
          (catppuccin-bat + "/Catppuccin-macchiato.tmTheme");
      };
    };

    neovim = {
      enable = true;

      plugins = with pkgs; [
        vimPlugins.copilot-vim
        vimPlugins.vim-fugitive
        vimPlugins.vim-rhubarb
        vimPlugins.nvim-fzf
        vimPlugins.plenary-nvim
        vimPlugins.telescope-nvim
        vimPlugins.telescope-fzf-native-nvim
        vimPlugins.lualine-nvim
        vimPlugins.nvim-fzf
        vimPlugins.vim-qml
        vimPlugins.catppuccin-vim
        vimPlugins.vim-be-good
        vimPlugins.cmp-git
        vimPlugins.git-worktree-nvim
        vimPlugins.harpoon
        vimPlugins.gitsigns-nvim
        vimPlugins.fzf-checkout-vim
        vimPlugins.firenvim
        vimPlugins.fidget-nvim
        vimPlugins.neodev-nvim
        vimPlugins.lsp-zero-nvim
        vimPlugins.mason-tool-installer-nvim
        vimPlugins.mason-nvim
        vimPlugins.mason-lspconfig-nvim
        vimPlugins.nvim-lspconfig
        vimPlugins.nvim-cmp
        vimPlugins.cmp-buffer
        vimPlugins.cmp-path
        vimPlugins.cmp_luasnip
        vimPlugins.cmp-nvim-lsp
        vimPlugins.cmp-nvim-lua
        vimPlugins.luasnip
        vimPlugins.friendly-snippets
        vimPlugins.rust-vim
        vimPlugins.cmp-cmdline
        vimPlugins.lspkind-nvim
        vimPlugins.lsp_extensions-nvim
        vimPlugins.cmp-nvim-lsp-document-symbol
        vimPlugins.tabnine-vim
        vimPlugins.cmp-tabnine
        vimPlugins.vim-clang-format
        vimPlugins.undotree
        vimPlugins.nvim-web-devicons
        vimPlugins.nvim-treesitter.withAllGrammars
        vimPlugins.nvim-treesitter-textobjects
        vimPlugins.playground
        vimPlugins.nvim-treesitter-context
        vimPlugins.markdown-preview-nvim
        vimPlugins.zen-mode-nvim
        vimPlugins.comment-nvim
        vimPlugins.vim-sleuth
        vimPlugins.lualine-nvim
        vimPlugins.lspsaga-nvim
        vimPlugins.nvim-notify
        vimPlugins.nvim-lint
        vimPlugins.vim-go
      ];
    };
  };

  programs.home-manager.enable = true;
}
