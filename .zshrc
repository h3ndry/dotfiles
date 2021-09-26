# Simnanga Hendry Khoza
# Tue Jun  8 13:36:08 2021

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

alias s='dwmswallow $WINDOWID;'

bindkey '^\' accept-line-swallow
bindkey -a '^\' accept-line-swallow

zle -N accept-line-swallow acceptandswallow
acceptandswallow() {
    dwmswallow $WINDOWID
    zle accept-line
}

zstyle ':completion:*' completer _expand_alias _complete _ignored

# History in cache directory:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
setopt appendhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

function expand-alias() {
	zle _expand_alias
	zle self-insert
}
zle -N expand-alias
bindkey -M main ' ' expand-alias

# vi mode
bindkey -v

export KEYTIMEOUT=1

bindkey '^ ' autosuggest-accept
bindkey -a '^ ' autosuggest-accept

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

### "bat" as manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export PATH='/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/local/go/bin:/usr/local/nvim/bin:/usr/local/go/bin:/usr/local/nvim/bin:/usr/local/go/bin:/usr/local/nvim/bin:/home/hendry/.dotnet/tools'

source ~/.zsh/aliases.sh
# source ~/.zsh/zsh-z/zsh-z.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autopair/autopair.zsh

# I love this plugin but it is too slow
# source ~/.zsh/zsh-vi-mode/zsh-vi-mode.plugin.zsh
