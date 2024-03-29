#zmodload zsh/zprof

case $TERM in
    xterm*)
        precmd () {print -Pn "\e]0;string\a"}
        ;;
esac

autoload -Uz vcs_info
zstyle ':vcs_info:git*' formats "(%b)"
zstyle ':vcs_info:*' check-for-changes true "(%b*)"
precmd() {
    vcs_info
}

bindkey -v

autoload -U colors && colors

setopt prompt_subst
# zstyle ':vcs_info:git*' actionformats "%s  %r/%S %b %m%u%c "

PROMPT='%{$fg[green]%}%c%{$reset_color%}${vcs_info_msg_0_} $ '

# print -n "\033k TITLE \033\134"

  # print -n "\033]0; st $(pwd | sed -e "s;^$HOME;~;")\a"


# bindkey -M vicmd v edit-command-line

zle -N accept-line-swallow acceptandswallow

acceptandswallow() {
    dwmswallow $WINDOWID
    zle accept-line
}

zstyle ':completion:*' completer _expand_alias _complete _ignored

# History in cache directory:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh/history
setopt appendhistory
fpath+=~/.zfunc
# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.



# vi mode
bindkey -v
export KEYTIMEOUT=1

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char
bindkey -M menuselect '^h' vi-backward-char

 zstyle ':completion:*:descriptions' format '%B%d%b'
    zstyle ':completion:*:messages' format '%d'
    zstyle ':completion:*:warnings' format 'No matches for: %d'
    zstyle ':completion:*' group-name ''

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

bindkey '^y' autosuggest-accept
bindkey -a '^y' autosuggest-accept

bindkey '^k' autosuggest-accept
bindkey -a '^k' autosuggest-accept


function expand-alias() {
	zle _expand_alias
	zle self-insert
}
zle -N expand-alias
bindkey -M main ' ' expand-alias



# This is NNN staff, please bare with mere here, I am still cooking
export NNN_FIFO=/tmp/nnn.fifo
export NNN_PLUG='p:preview-tabbed;z:autojump;a:mtpmount;m:nmount;c:term'
# export NNN_PLUG='f:finder;o:fzopen;p:mocq;d:diffs;t:nmount;v:imgview'


# alias s='dwmswallow $WINDOWID;'
# bindkey '^\' accept-line-swallow
# bindkey -a '^\' accept-line-swallow

# # Change cursor shape for different vi modes.
# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]] ||
#      [[ $1 = 'block' ]]; then
#     echo -ne '\e[1 q'
#   elif [[ ${KEYMAP} == main ]] ||
#        [[ ${KEYMAP} == viins ]] ||
#        [[ ${KEYMAP} = '' ]] ||
#        [[ $1 = 'beam' ]]; then
#     echo -ne '\e[5 q'
#   fi
# }
# zle -N zle-keymap-select
# zle-line-init() {
#     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#     echo -ne "\e[5 q"
# }
# zle -N zle-line-init
# echo -ne '\e[5 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# zsh parameter completion for the dotnet CLI
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")
  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

### "bat" as manpager
# export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export PATH='/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/local/nvim/bin:/usr/local/go/bin:/home/hendry/.dotnet/tools:/home/hendry/.cargo/bin:/home/hendry/.local/bin:/home/hendry/.local/share/gem/ruby/3.0.0/bin'

# bas dir for all cd command
export CDPATH=/home/hendry

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(direnv hook zsh)"
export PATH="$HOME/.poetry/bin:$PATH"
# Load pyenv automatically by appending
# the following to
# ~/.zprofile (for login shells)
# and ~/.zshrc (for interactive shells) :

# bun completions

# bun
export PATH="$BUN_INSTALL/bin:$PATH"
export EDITOR=nvim

source ~/.zsh/zsh-vi-mode.zsh
source ~/.zsh/autopair.zsh
source ~/.zsh/aliases.sh
source ~/.zsh/zsh-autosuggestions.zsh
source ~/.zsh/zsh-256color.plugin.zsh
source ~/.zsh/fast-syntax-highlighting.plugin.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source /etc/profile.d/google-cloud-cli.sh
# source /opt/esp-idf/export.sh

# bun completions
[ -s "/home/hendry/.bun/_bun" ] && source "/home/hendry/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bindkey '^R' history-incremental-search-backward


# JINA_CLI_BEGIN

## autocomplete
if [[ ! -o interactive ]]; then
    return
fi

compctl -K _jina jina

_jina() {
  local words completions
  read -cA words

  if [ "${#words}" -eq 2 ]; then
    completions="$(jina commands)"
  else
    completions="$(jina completions ${words[2,-2]})"
  fi

  reply=(${(ps:
:)completions})
}

# session-wise fix
ulimit -n 4096
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# JINA_CLI_END

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(zoxide init --cmd cd zsh)"

export VISUAL=ewrap

