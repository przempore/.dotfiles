starship init fish | source

set EDITOR nvim

set -gx PATH $HOME/.cargo/bin $HOME/.local/bin $HOME/.local/bin/private $HOME/.local/share/nvim/lsp_servers/rust $HOME/go/bin $PATH

function s
    kitty +kitten ssh $argv
end

function vi
    nvim $argv
end

function ll
    eza --tree --level=1 --long --icons --git -lh $argv
end

function lah
    ll -lah $argv
end

function glog
    git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
end

function asdf
    $HOME/.config/bspwm/scripts/refresh-keyboard.sh --variant=dvorak
end

function aoeu
    $HOME/.config/bspwm/scripts/refresh-keyboard.sh --variant=qwerty &
end

function asdfc
    $HOME/.config/bspwm/scripts/refresh-keyboard.sh --variant=dvorak --set_CTRL &
end

function aoeuc
    $HOME/.config/bspwm/scripts/refresh-keyboard.sh --variant=qwerty --set_CTRL &
end

function de
    setxkbmap de
end

function pl
    setxkbmap pl
end

function convert_mkv_to_mp4
    ffmpeg -i $argv[1] -codec copy $argv[2]
end

function vi
    nvim $argv
end

if set -q IS_WEZTERM
    function rename_tab
        wezterm cli set-tab-title $argv
    end
end

[ -f /home/porebski/.dotfiles/private/fish/config.fish ]; and source /home/porebski/.dotfiles/private/fish/config.fish

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline
