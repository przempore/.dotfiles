require'nvim-treesitter.configs'.setup {
    -- ensure_installed = {"c", "cpp", "bash", "cmake", "diff", "dockerfile", "dot", "fish", "git_rebase",
    --                     "gitattributes", "gitcommit", "gitignore", "json", "markdown", "meson", "proto",
    --                     "go", "latex", "llvm", "make", "lua", "ninja", "perl", "ql", "qmljs", "scheme",
    --                     "sql", "todotxt", "python", "rust", "sxhkdrc", "toml", "vim", "yaml"},
    sync_install = false,

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    autotag = {
        enable = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = 1000,
    },
}
