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
PROMPT='%{$fg[green]%}%c%{$reset_color%}${vcs_info_msg_0_}$ '

alias s='dwmswallow $WINDOWID;'

bindkey '^\' accept-line-swallow
bindkey -a '^\' accept-line-swallow

zle -N accept-line-swallow acceptandswallow
acceptandswallow() {
    dwmswallow $WINDOWID
    zle accept-line
}

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt appendhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# vi mode
bindkey -v
export KEYTIMEOUT=1
# bindkey '^l' autosuggest-accept
# bindkey -a '^l' autosuggest-accept

bindkey '^ ' autosuggest-accept
bindkey -a '^ ' autosuggest-accept

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

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

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' 'lfcd\n'

# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line


### "bat" as manpager
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

### "vim" as manpager
# export MANPAGER='/bin/bash -c "vim -MRn -c \"set buftype=nofile showtabline=0 ft=man ts=8 nomod nolist norelativenumber nonu noma\" -c \"normal L\" -c \"nmap q :qa<CR>\"</dev/tty <(col -b)"'

### "nvim" as manpager
# export MANPAGER="nvim -c 'set ft=man' -"




export PATH='/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/lib/jvm/default/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl:/usr/local/go/bin:/usr/local/nvim/bin:/usr/local/go/bin:/usr/local/nvim/bin:/usr/local/go/bin:/usr/local/nvim/bin:/home/hendry/.dotnet/tools'

source ~/.zsh/aliases.sh
# source ~/.zsh/zsh-z/zsh-z.plugin.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

