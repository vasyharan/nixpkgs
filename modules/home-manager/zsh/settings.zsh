# autosuggest {{{
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=14" # solarized light
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10" # solarized dark
# }}}

# PATH=~/.npm-packages/bin:$PATH
# NODE_PATH="~/.npm-packages/lib/node_modules"

# highlight styles {{{
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES;
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none
# }}}

# ripgrep {{{
RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc
# }}}

# {{{ fzf
# export FZF_CTRL_T_COMMAND="rg --files"
# export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS="--bind 'change:top,ctrl-s:toggle' --bind 'ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up'"
# }}}
# {{{ git❤️fzf
# https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --min-height 20 --border --bind ctrl-/:toggle-preview "$@"
  # fzf "$@" --border
}

_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
  cut -c4- | sed 's/.* -> //'
}

_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {}'
}

_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
  grep -o "[a-f0-9]\{7,\}"
}

_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
  cut -d$'\t' -f1
}

_gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

_gp() {
  is_in_git_repo || return
  gh_template='
    {{- range . -}}
        {{- $stateColor := "green" -}}
        {{- if eq .isDraft true -}}
            {{- $stateColor = "white+dh" -}}
        {{- else if eq .state "CLOSED" -}}
            {{- $stateColor = "red" -}}
        {{- else if eq .state "MERGED" -}}
            {{- $stateColor = "magenta" -}}
        {{- end -}}

        {{- tablerow
            (printf "#%v" .number | autocolor $stateColor)
            (truncate 90 (.title | autocolor "white+h"))
            (truncate 60 (.headRefName | autocolor "white+h"))
            (printf "%15s" (timeago .updatedAt) | autocolor "white+d")
        -}}
    {{- end -}}
  '
  gh pr list -A "@me" --json "number,title,state,headRefName,updatedAt,isDraft" --template $gh_template |
    fzf-down --ansi --preview 'gh pr diff {1}' --bind 'enter:execute(gh pr view -w {1})+abort'
}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r h s p
unset -f bind-git-helper
# }}}

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f ~/.config/zsh/secrets ]] || source ~/.config/zsh/secrets

random-hex() {
  openssl rand -hex ''${1:-4} | head -c ''${1:-4} | tr 'A-F' 'a-f'
}

random-uuid() {
  uuidgen | tr '[:upper:]' '[:lower:]' | tr -d '\n'
}

if type zellij > /dev/null; then
  if [[ -o interactive && "${TERM_PROGRAM}" == "ghostty" ]]; then
    export ZELLIJ_AUTO_EXIT=true
    export ZELLIJ_AUTO_ATTACH=true
    eval "$(zellij setup --generate-auto-start zsh)"
  fi
fi
