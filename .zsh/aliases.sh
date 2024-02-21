# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias mpv='dwmswallow $WINDOWID & mpv'
alias zathura='dwmswallow $WINDOWID & zathura'
alias feh='dwmswallow $WINDOWID & feh'
alias scrcpy='dwmswallow $WINDOWID & scrcpy'


alias vi='nvim'

alias config='git --git-dir=/home/hendry/.cfg/ --work-tree=/home/hendry'

alias md='mkdir -p'

# # Changing "ls" to "exa"
# alias ls='exa -a --color=always --group-directories-first' # my preferred listing
# alias la='exa -a --color=always --group-directories-first'  # all files and dirs
# alias ll='exa -l --color=always --group-directories-first'  # long format
# alias lt='exa -aT --color=always --group-directories-first' # tree listing
# alias l.='exa -a | egrep "^\."'
# alias ld='ls -d -- */'

# # Colorize grep output (good for log files)
# alias grep='grep --color=auto'
# alias egrep='egrep --color=auto'
# alias fgrep='fgrep --color=auto'

# # confirm before overwriting something
# alias cp="rsync -i"
# alias mv='mv -i'
# alias rm='rm -i'

# yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-m4a="yt-dlp --extract-audio --audio-format m4a "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias yta-opus="yt-dlp --extract-audio --audio-format opus "
alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis "
alias yta-wav="yt-dlp --extract-audio --audio-format wav "
alias ytv-best="yt-dlp -f bestvideo+bestaudio "






if (( $+commands[paru] )); then
  alias yaconf='paru -Pg'
  alias yaupg='paru -Syu'
  alias yasu='paru -Syu --noconfirm'
  alias yain='paru -S'
  alias yains='paru -U'
  alias yare='paru -R'
  alias yarem='paru -Rns'
  alias yarep='paru -Si'
  alias yareps='paru -Ss'
  alias yaloc='paru -Qi'
  alias yalocs='paru -Qs'
  alias yalst='paru -Qe'
  alias yaorph='paru -Qtd'
  alias yainsd='paru -S --asdeps'
  alias yamir='paru -Syy'
  alias yaupd="paru -Sy"
  alias upgrade='paru -Syu'
fi

#######################################
#               Pacman                #
#######################################

# Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
alias pacupg='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias pacins='sudo pacman -U'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias pacinsd='sudo pacman -S --asdeps'
alias pacmir='sudo pacman -Syy'
alias paclsorphans='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'
alias pacfileupg='sudo pacman -Fy'
alias pacfiles='pacman -F'
alias pacls='pacman -Ql'
alias pacown='pacman -Qo'
alias pacupd="sudo pacman -Sy"
alias upgrade='sudo pacman -Syu'

function paclist() {
  # Based on https://bbs.archlinux.org/viewtopic.php?id=93683
  pacman -Qqe | \
    xargs -I '{}' \
      expac "${bold_color}% 20n ${fg_no_bold[white]}%d${reset_color}" '{}'
}

function pacdisowned() {
  local tmp db fs
  tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
  db=$tmp/db
  fs=$tmp/fs

  mkdir "$tmp"
  trap 'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr ! -name lost+found \
    \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

  comm -23 "$fs" "$db"
}

alias pacmanallkeys='sudo pacman-key --refresh-keys'

function pacmansignkeys() {
  local key
  for key in $@; do
    sudo pacman-key --recv-keys $key
    sudo pacman-key --lsign-key $key
    printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
      --no-permission-warning --command-fd 0 --edit-key $key
  done
}

if (( $+commands[xdg-open] )); then
  function pacweb() {
    if [[ $# = 0 || "$1" =~ '--help|-h' ]]; then
      local underline_color="\e[${color[underline]}m"
      echo "$0 - open the website of an ArchLinux package"
      echo
      echo "Usage:"
      echo "    $bold_color$0$reset_color ${underline_color}target${reset_color}"
      return 1
    fi

    local pkg="$1"
    local infos="$(LANG=C pacman -Si "$pkg")"
    if [[ -z "$infos" ]]; then
      return
    fi
    local repo="$(grep -m 1 '^Repo' <<< "$infos" | grep -oP '[^ ]+$')"
    local arch="$(grep -m 1 '^Arch' <<< "$infos" | grep -oP '[^ ]+$')"
    xdg-open "https://www.archlinux.org/packages/$repo/$arch/$pkg/" &>/dev/null
  }
fi


# Git version checking
autoload -Uz is-at-least
git_version="${${(As: :)$(git version 2>/dev/null)}[3]}"

#
# Functions
#

# The name of the current branch
# Back-compatibility wrapper for when this function was defined here in
# the plugin, before being pulled in to core lib/git.zsh as git_current_branch()
# to fix the core -> git plugin dependency.
function git_current_branch() {
  # git_current_branch
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
compdef _git _git_log_prettily=git-log

# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local branch
  for branch in main trunk; do
    if command git show-ref -q --verify refs/heads/$branch; then
      echo $branch
      return
    fi
  done
  echo master
}

#
# Aliases
# (sorted alphabetically)
#

alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'
alias gap='git apply'
alias gapt='git apply --3way'

alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^(\+|\*|\s*($(git_main_branch)|development|develop|devel|dev)\s*$)" | command xargs -n 1 git branch -d'
alias gbD='git branch -D'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcans!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'
alias gcsm='git commit -s -m'
alias gcas='git commit -a -s'
alias gcasm='git commit -a -s -m'
alias gcb='git checkout -b'
alias gcf='git config --list'
alias gcl='git clone --recurse-submodules'
alias gclean='git clean -id'
alias gpristine='git reset --hard && git clean -dffx'
alias gcm='git checkout $(git_main_branch)'
alias gcd='git checkout develop'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gcs='git commit -S'

alias gd='git diff'
alias gdca='git diff --cached'
alias gdcw='git diff --cached --word-diff'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdw='git diff --word-diff'

function gdnolock() {
  git diff "$@" ":(exclude)package-lock.json" ":(exclude)*.lock"
}
compdef _git gdnolock=git-diff

function gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff

alias gf='git fetch'
# --jobs=<n> was added in git 2.8
is-at-least 2.8 "$git_version" \
  && alias gfa='git fetch --all --prune --jobs=10' \
  || alias gfa='git fetch --all --prune'
alias gfo='git fetch origin'

alias gfg='git ls-files | grep'

alias gg='git gui citool'
alias gga='git gui citool --amend'

function ggf() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force origin "${b:=$1}"
}
compdef _git ggf=git-checkout
function ggfl() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git push --force-with-lease origin "${b:=$1}"
}
compdef _git ggfl=git-checkout

function ggl() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git pull origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git pull origin "${b:=$1}"
  fi
}
compdef _git ggl=git-checkout

function ggp() {
  if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
    git push origin "${*}"
  else
    [[ "$#" == 0 ]] && local b="$(git_current_branch)"
    git push origin "${b:=$1}"
  fi
}
compdef _git ggp=git-checkout

function ggpnp() {
  if [[ "$#" == 0 ]]; then
    ggl && ggp
  else
    ggl "${*}" && ggp "${*}"
  fi
}
compdef _git ggpnp=git-checkout

function ggu() {
  [[ "$#" != 1 ]] && local b="$(git_current_branch)"
  git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout

alias ggpur='ggu'
alias ggpull='git pull origin "$(git_current_branch)"'
alias ggpush='git push origin "$(git_current_branch)"'

alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

alias ghh='git help'

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'

alias gk='\gitk --all --branches'
alias gke='\gitk --all $(git log -g --pretty=%h)'

alias gl='git pull'
alias glg='git log --stat'
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp="_git_log_prettily"

alias gm='git merge'
alias gmom='git merge origin/$(git_main_branch)'
alias gmt='git mergetool --no-prompt'
alias gmtvim='git mergetool --no-prompt --tool=vimdiff'
alias gmum='git merge upstream/$(git_main_branch)'
alias gma='git merge --abort'

alias gp='git push'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpu='git push upstream'
alias gpv='git push -v'

alias gr='git remote'
alias gra='git remote add'
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase develop'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'
alias grev='git revert'
alias grh='git reset'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_current_branch) --hard'
alias grm='git rm'
alias grmc='git rm --cached'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grs='git restore'
alias grset='git remote set-url'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'
alias gru='git reset --'
alias grup='git remote update'
alias grv='git remote -v'

alias gsb='git status -sb'
alias gsd='git svn dcommit'
alias gsh='git show'
alias gsi='git submodule init'
alias gsps='git show --pretty=short --show-signature'
alias gsr='git svn rebase'
alias gss='git status -s'
alias gst='git status'

# use the default stash push on git 2.13 and newer
is-at-least 2.13 "$git_version" \
  && alias gsta='git stash push' \
  || alias gsta='git stash save'

alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='gsta --include-untracked'
alias gstall='git stash --all'
alias gsu='git submodule update'
alias gsw='git switch'
alias gswc='git switch -c'

alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'

alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash -v'
alias glum='git pull upstream $(git_main_branch)'

alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

alias gam='git am'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gama='git am --abort'
alias gamscp='git am --show-current-patch'

function grename() {
  if [[ -z "$1" || -z "$2" ]]; then
    echo "Usage: $0 old_branch new_branch"
    return 1
  fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
    git push --set-upstream origin "$2"
  fi
}

unset git_version


############################################################################
#                                                                          #
#               ------- Useful Docker Aliases --------                     #
#                                                                          #
#     # Installation :                                                     #
#     copy/paste these lines into your .bashrc or .zshrc file or just      #
#     type the following in your current shell to try it out:              #
#     wget -O - https://gist.githubusercontent.com/jgrodziski/9ed4a17709baad10dbcd4530b60dfcbb/raw/d84ef1741c59e7ab07fb055a70df1830584c6c18/docker-aliases.sh | bash
#                                                                          #
#     # Usage:                                                             #
#     daws <svc> <cmd> <opts> : aws cli in docker with <svc> <cmd> <opts>  #
#     dc             : docker compose                                      #
#     dcu            : docker compose up -d                                #
#     dcd            : docker compose down                                 #
#     dcr            : docker compose run                                  #
#     dex <container>: execute a bash shell inside the RUNNING <container> #
#     di <container> : docker inspect <container>                          #
#     dim            : docker images                                       #
#     dip            : IP addresses of all running containers              #
#     dl <container> : docker logs -f <container>                          #
#     dnames         : names of all running containers                     #
#     dps            : docker ps                                           #
#     dpsa           : docker ps -a                                        #
#     drmc           : remove all exited containers                        #
#     drmid          : remove all dangling images                          #
#     drun <image>   : execute a bash shell in NEW container from <image>  #
#     dsr <container>: stop then remove <container>                        #
#                                                                          #
############################################################################

function dnames-fn {
	for ID in `docker ps | awk '{print $1}' | grep -v 'CONTAINER'`
	do
    	docker inspect $ID | grep Name | head -1 | awk '{print $2}' | sed 's/,//g' | sed 's%/%%g' | sed 's/"//g'
	done
}

function dip-fn {
    echo "IP addresses of all named running containers"

    for DOC in `dnames-fn`
    do
        IP=`docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$DOC"`
        OUT+=$DOC'\t'$IP'\n'
    done
    echo -e $OUT | column -t
    unset OUT
}

function dex-fn {
	docker exec -it $1 ${2:-bash}
}

function di-fn {
	docker inspect $1
}

function dl-fn {
	docker logs -f $1
}

function drun-fn {
	docker run -it $1 $2
}

function dcr-fn {
	docker compose run $@
}

function dsr-fn {
	docker stop $1;docker rm $1
}

function drmc-fn {
       docker rm $(docker ps --all -q -f status=exited)
}

function drmid-fn {
       imgs=$(docker images -q -f dangling=true)
       [ ! -z "$imgs" ] && docker rmi "$imgs" || echo "no dangling images."
}

# in order to do things like dex $(dlab label) sh
function dlab {
       docker ps --filter="label=$1" --format="{{.ID}}"
}

function dc-fn {
        docker compose $*
}

function d-aws-cli-fn {
    docker run \
           -e AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
           -e AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION \
           -e AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
           amazon/aws-cli:latest $1 $2 $3
}

alias daws=d-aws-cli-fn
alias dc=dc-fn
alias dcu="docker compose up -d"
alias dcd="docker compose down"
alias dcr=dcr-fn
alias dex=dex-fn
alias di=di-fn
alias dim="docker images"
alias dip=dip-fn
alias dl=dl-fn
alias dnames=dnames-fn
alias dps="docker ps"
alias dpsa="docker ps -a"
alias drmc=drmc-fn
alias drmid=drmid-fn
alias drun=drun-fn
alias dsp="docker system prune --all"
alias dsr=dsr-fn




KALIAS=$ZSH_CUSTOM/plugins/kube-aliases
KRESOURCES=$ZSH_CUSTOM/plugins/kube-aliases/docs/resources
SHELL_NAME=$(basename $SHELL)

# Auto complete, for bash replace zsh with bash
# For some reason this is sourcing the oh-my-zsh plugin.
source <(kubectl completion $SHELL_NAME)

# Contexts
alias kcc='kubectl config get-contexts'
alias kctx='kubectx'

# Core
alias k='kubectl'
alias kc='kubectl'
alias kube='kubectl'
alias kd='kubectl delete'
alias kds='kubectl describe service'
alias ke='kubectl edit'
alias kg='kubectl get'
alias kga='kubectl get --all-namespaces'
alias kl='kubectl logs'
alias kcl='kubectl logs'
alias klf='kubectl logs -f'

# certificatesigningrequests
alias kgcsr='kubectl get certificatesigningrequests'

# clusterrolebindings
alias kgcrb='kubectl get clusterrolebindings'

# clusterroles
alias kgcr='kubectl get clusterroles'

# componentstatuses
alias kgcs='kubectl get componentstatus'

# configmaps
alias kdcm='kubectl delete configmaps'
alias kdscm='kubectl describe configmaps'
alias kecm='kubectl edit configmaps'
alias kgcm='kubectl get configmaps'
alias kgcmy='kubectl get configmaps -o yaml'
alias kgacm='get_cluster_resources configmaps'

# controllerrevisions
alias kgcrv='kubectl get controllerrevisions'

# Cronjobs
alias kdc='kubectl delete cronjobs'
alias kdsc='kubectl describe cronjobs'
alias kec='kubectl edit cronjobs'
alias kgc='kubectl get cronjobs'
alias kgcw='watch kubectl get cronjobs'
alias kgcy='kubectl get cronjobs -o yaml'
alias kgac='get_cluster_resources cronjobs'

# customresourcedefinition
alias kgcrd='kubectl get customresourcedefinition'

# daemonsets
alias kdds='kubectl delete daemonsets'
alias kdsds='kubectl describe daemonsets'
alias keds='kubectl edit daemonsets'
alias kgds='kubectl get daemonsets'
alias kgdsw='watch kubectl get daemonsets'
alias kgdsy='kubectl get daemonsets -o yaml'
alias kgads='get_cluster_resources daemonsets'

# Deployments
alias kdd='kubectl delete deployment'
alias kdsd='kubectl describe deployments'
alias ked='kubectl edit deployments'
alias kgd='kubectl get deployments'
alias kgdw='watch kubectl get deployments'
alias kgdy='kubectl get deployments -o yaml'

# endpoints
alias kgep='kubectl get endpoints'

# events
alias kgev='kubectl get events'

# from file
alias kaf='kubectl apply -f'
alias kcf='kubectl create -f'
alias kdf='kubectl delete -f'
alias kef='kubectl edit -f'
alias kdsf='kubectl describe -f'
alias kgf='kubectl get -f'

# horizontalpodautoscalers
alias kghpa='kubectl get horizontalpodautoscalers'

# Ingress
alias kdi='kubectl delete ingress'
alias kdsi='kubectl describe ingress'
alias kei='kubectl edit ingress'
alias kgai='get_cluster_resources ingress'
alias kgi='kubectl get ingress'
alias kgiy='kubectl get ingress -o yaml'

# Jobs
alias kdj='kubectl delete job'
alias kdsj='kubectl describe jobs'
alias kej='kubectl edit jobs'
alias kgj='kubectl get jobs'
alias kgjw='watch kubectl get jobs'
alias kgjy='kubectl get jobs -o yaml'
alias kgaj='get_cluster_resources jobs'

# limitranges
alias kglr='kubectl get limitranges'

# Namespaces
alias kdns='kubectl delete namespaces'
alias kdsns='kubectl describe namespaces'
alias kens='kubectl edit namespaces'
alias kgns='kubectl get namespaces'
alias kgnsy='kubectl get namespaces -o yaml'
alias kns='kubens'

# networkpolicies
alias kgnp='kubectl get networkpolicies'

# Nodes
alias kdsn='kubectl describe nodes'
alias ken='kubectl edit nodes'
alias kgn='kubectl get nodes'
alias kgny='kubectl get nodes -o yaml'
alias ktn='kubectl top nodes'

# persistentvolumeclaims
alias kdpvc='kubectl delete persistentvolumeclaims'
alias kdspvc='kubectl describe persistentvolumeclaims'
alias kepvc='kubectl edit persistentvolumeclaims'
alias kgapvc='get_cluster_resources persistentvolumeclaims'
alias kgpvc='kubectl get persistentvolumeclaims'
alias kgpvcy='kubectl get persistentvolumeclaims -o yaml'

# persistentvolumes
alias kdpv='kubectl delete persistentvolumes'
alias kdspv='kubectl describe persistentvolumes'
alias kepv='kubectl edit persistentvolumes'
alias kgpv='kubectl get persistentvolumes'
alias kgpvy='kubectl get persistentvolumes -o yaml'

# poddisruptionbudgets
alias kgpdb='kubectl get poddisruptionbudgets'

# podpreset
alias kgpp='kubectl get podpreset'

# Pods
alias kdp='kubectl delete pod'
alias kdsp='kubectl describe pods'
alias kep='kubectl edit pods'
alias kgap='get_cluster_resources pods'
alias kgp='kubectl get pods'
alias kgpw='watch kubectl get pods'
alias kgpy='kubectl get pods -o yaml'
alias ktp='kubectl top pods'

# podsecuritypolicies
alias kpsp='kubectl get podsecuritypolicies'

# podtemplates
alias kpt='kubectl get podtemplates'

# replicasets
alias krs='kubectl get replicasets'

# replicationcontrollers
alias kgrc='kubectl get replicationcontrollers'

# resourcequotas
alias kgrq='kubectl get resourcequotas'

# rolebindings
alias kgrb='kubectl get rolebindings'

# roles
alias kgr='kubectl get roles'

# secrets
alias kdssc='kubectl describe secrets'
alias kesc='kubectl edit secrets'
alias kgasc='get_cluster_resources secrets'
alias kgsc='kubectl get secrets'
alias kgscy='kubectl get secrets -o yaml'

# serviceaccounts
alias kgsa='kubectl get serviceaccounts'

# Services
alias kds='kubectl delete services'
alias kdss='kubectl describe services'
alias kes='kubectl edit services'
alias kgas='get_cluster_resources services'
alias kgs='kubectl get services'
alias kgsy='kubectl get services -o yaml'

# statefulsets
alias kgss='kubectl get statefulsets'

# Execute a command in a specified pod, default drops user into the shell
alias keit='kubectl exec -it --'

kcexec () {
  kubectl exec -it $1 -- ${2:-bash}
}
kexec () {
  kubectl exec -it $1 -- ${2:-bash}
}

# Set and use a new context
knc () {
  kc config set-context $1
  kc config use-context $1
}

# TODO: kpf name conflict from sourcing autocomplete
# kpf () {
#   kubectl port-forward $1 9990:9990 --namespace=${2}
# }

# Get all resources (e.g. pod) in all namespaces
get_cluster_resources () {
  kubectl get $1 -o wide --all-namespaces ${@:2}
}

# TODO: Go through all resources.
# Find a resource (e.g. a pod by name)
kfind () {

  # kubectl get all --all-namespaces | grep -i -E --color=always "${@}|$"
  sed 1d $KRESOURCES | while read resource; do
    kubectl get $resource --all-namespaces -o wide 2>/dev/null | \
      $KALIAS/src/kfind.awk -v regex="${1}" -v resourcetype="${resource}"
  done

#   local custom=$(kubectl get customresourcedefinition)
#   echo $custom | while read resource; do
#     kubectl get "${resource}" --all-namespaces -o wide | \
#       $KALIAS/src/kfind.awk -v regex="${1}" -v resourcetype="${resource}"
  # done
}

# Start a restart on pods, will follow the rolling release policy
krd () {
  kubectl patch deployment ${1} -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"
}

# Search pods using regular expression
kpfind () {

  column -t <<< $(kubectl get pods --all-namespaces -o wide | \
    $KALIAS/src/kpfind.awk -v regex="${1}")

}

# Search pods using regular expression
kstatus () {

  # Structured after stack exchange
  iPOSITIONAL=()
  while [[ $# -gt 0 ]]
  do
  key="$1"

  case $key in
    -C) 
      kpfind Completed
      shift
      ;;
    -c) 
      kpfind CrashLoopBackOff
      shift
      ;;
    -f) 
      kpfind Failed
      shift
      ;;
    -p) 
      kpfind Pending
      shift
      ;;
    -r) 
      kpfind Running
      shift
      ;;
    -s) 
      kpfind Succeded
      shift
      ;;
    -u) 
      kpfind Unknown
      shift
      ;;
    -h) 
      echo "Usage: kstatus -[C|c|f|p|r|s|u]"
      echo "  -C                           Completed"
      echo "  -c                           CrashLoopBackOff"
      echo "  -f                           Failed"
      echo "  -p                           Pending"
      echo "  -r                           Running"
      echo "  -s                           Succeeded"
      echo "  -u                           Unknown"
      shift
      ;;
  esac
  done
  set -- "${POSITIONAL[@]}" # restore positional parameters

}


# Display help
khelp () {

case $1 in
  commands|cmd|usage)
    cat $KALIAS/docs/usage
  ;;
  resources|res)
    cat $KALIAS/docs/resources
    kubectl get customresourcedefinition | awk 'NR>1 {print $1}'
  ;;
  *)
    echo "usage: khelp (cmd|res)"
  ;;
esac

}

# Get the pod names (just the names) of all pods in a namespace.
kgpns () {
  echo $(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{" "}}{{end}}')
}

# Delete all pods within a namespace.
kdap () {

  if [ $SHELL_NAME = zsh ]; then
    read "kdelete?This will attempt to delete all pods within the namespace. Do you want to continue?(y/N) "
  else
    read -p "This will attempt to delete all pods within the namespace. Do you want to continue?(y/N) " kdelete
  fi

  if [[ "${kdelete}" =~ ^[yY]$ ]]; then
    kubectl delete pods $(kgpns)
  fi
}

# Drain node
kdrain () {

  if [ $SHELL_NAME = zsh ]; then
    read "kdrainnode? This will drain the node ${1}, delete local data, and ignore daemonsets. Do you want to continue?(y/N) "
  else
    read -p "This will drain the node ${1}, delete local data, and ignore daemonsets. Do you want to continue?(y/N) " kdrainnode
  fi

  if [[ "${kdrainnode}" =~ ^[yY]$ ]]; then
    kubectl drain ${1} --delete-local-data --force --ignore-daemonsets
  fi
}

# Intended to be a private function
_cp_config_sed_config () {
  local resource=${1}
  local name=${2}
  cp ${KALIAS}/include/${1}.yaml ${name}-${resource}.yaml
  sed -i "s/CHANGEME/${2}/g" ${name}-${resource}.yaml
}

# Create config
kcon () {
  local configPath=$KALIAS/include/
  # Structured after stack exchange
  iPOSITIONAL=()
  while [[ $# -gt 0 ]]
  do
  key="$1"

  case $key in
    -a)
      local resources=(configmap deployment ingress namespace service)
      for resource in $resources; do
        _cp_config_sed_config $resource ${2}
      done
      shift
      shift
      ;;
    -c)
      _cp_config_sed_config configmap ${2}
      shift
      shift
      ;;
    -d)
      _cp_config_sed_config deployment ${2}
      shift
      shift
      ;;
    -i)
      _cp_config_sed_config ingress ${2}
      shift
      shift
      ;;
    -n)
      _cp_config_sed_config namespace ${2}
      shift
      shift
      ;;
    -s)
      _cp_config_sed_config service ${2}
      shift
      shift
      ;;
    -h)
      echo "Usage: kcon -[c|d|i|n|s] NAME"
      echo "  -a                           Create all template files"
      echo "  -c                           Create configmap template"
      echo "  -d                           Create deployment template"
      echo "  -h                           Display usage"
      echo "  -i                           Create ingress template"
      echo "  -n                           Create namespace template"
      echo "  -s                           Create service template"

      shift # past argument
      ;;
  esac
  done
  set -- "${POSITIONAL[@]}" # restore positional parameters
}
