# Simnanga Hendry Khoza
# Tue Jun  8 13:36:08 2021

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
HISTFILE=~/.cache/zsh/history
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


function expand-alias() {
	zle _expand_alias
	zle self-insert
}
zle -N expand-alias
bindkey -M main ' ' expand-alias

alias s='dwmswallow $WINDOWID;'
bindkey '^\' accept-line-swallow
bindkey -a '^\' accept-line-swallow

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.


# zsh parameter completion for the dotnet CLI
_dotnet_zsh_complete()
{
  local completions=("$(dotnet complete "$words")")
  reply=( "${(ps:\n:)completions}" )
}

compctl -K _dotnet_zsh_complete dotnet

### "bat" as manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export PATH='/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/local/go/bin:/usr/local/nvim/bin:/usr/local/go/bin:/usr/local/nvim/bin:/usr/local/go/bin:/usr/local/nvim/bin:/home/hendry/.dotnet/tools:/home/hendry/.cargo/bin'

# bas dir for all cd command
export CDPATH=/home/hendry

source ~/.zsh/aliases.sh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autopair/autopair.zsh
source ~/workspace/cmdtime/cmdtime.plugin.zsh
# source "/home/hendry/workspace/emsdk/emsdk_env.sh"
# I love this plugin but it is too slow
# source ~/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh
#


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.poetry/bin:$PATH"
# Load pyenv automatically by appending
# the following to
# ~/.zprofile (for login shells)
# and ~/.zshrc (for interactive shells) :

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

eval "$(pyenv init -)"

# Restart your shell for the changes to take effect.


