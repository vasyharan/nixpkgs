[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export WORDCHARS= # configure word boundary

# autosuggest {{{
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=14" # solarized light
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10" # solarized dark
# }}}

# highlight styles {{{
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES;
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# }}}

# ripgrep {{{
RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
# }}}
