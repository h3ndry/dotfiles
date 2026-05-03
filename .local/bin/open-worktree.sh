#!/usr/bin/env sh

set -eu

CONNECT_CMD='sesh connect -c "nvim ." "{{ worktree_path }}"'

branch_preview() {
  repo_root=$1
  branch=${2-}
  repo_name=$(basename "$repo_root")

  if [ -z "$branch" ]; then
    printf 'Repo: %s\n\nSelect or type a branch name.\n' "$repo_name"
    exit 0
  fi

  printf 'Repo: %s\nBranch: %s\n\n' "$repo_name" "$branch"
  git -C "$repo_root" for-each-ref --format='%(refname:short) %(subject)' \
    "refs/heads/$branch" "refs/remotes/origin/$branch" 2>/dev/null | sed -n '1p'

  printf '\nStatus\n'
  git -C "$repo_root" status --short --branch 2>/dev/null || true

  printf '\nRecent commits\n'
  git -C "$repo_root" log --oneline --decorate -n 15 "$branch" 2>/dev/null || \
    printf 'No commit preview available for %s\n' "$branch"
}

if [ "${1-}" = '--preview-branch' ]; then
  branch_preview "$2" "${3-}"
  exit 0
fi

strip_selection() {
  printf '%s' "$1" | sed 's/\x1b\[[0-9;]*m//g; s/^[^[:space:]]*[[:space:]]*//'
}

resolve_repo_root() {
  if [ $# -gt 0 ] && [ -n "$1" ]; then
    selected=$(strip_selection "$1")
    selected=$(printf '%s' "$selected" | sed "s|^~|$HOME|")
    if [ -n "$selected" ] && [ -d "$selected" ]; then
      if [ "$(git -C "$selected" rev-parse --is-bare-repository 2>/dev/null || true)" = 'true' ]; then
        printf '%s\n' "$selected"
        return
      fi

      git -C "$selected" rev-parse --show-toplevel 2>/dev/null || true
      return
    fi
  fi

  if [ "$(git rev-parse --is-bare-repository 2>/dev/null || true)" = 'true' ]; then
    git rev-parse --absolute-git-dir 2>/dev/null || true
    return
  fi

  git rev-parse --show-toplevel 2>/dev/null || true
}

pause_and_exit() {
  printf '\nPress Enter to close...'
  read -r _
  exit 1
}

pick_action() {
  printf 'switch\ncreate\ndelete\n' | fzf \
    --prompt 'worktree > ' \
    --header "Repo: $repo_name | Choose action" \
    --layout=default \
    --height=100%
}

list_branches() {
  git for-each-ref --format='%(refname:short)' refs/heads refs/remotes 2>/dev/null \
    | sed '/^origin\/HEAD$/d; s#^origin/##' \
    | awk 'NF && !seen[$0]++'
}

pick_branch_to_switch() {
  list_branches | fzf \
    --prompt 'switch branch > ' \
    --header "Repo: $repo_name | Choose a branch" \
    --layout=default \
    --height=100% \
    --preview "$0 --preview-branch '$repo_root' {}" \
    --preview-window='right:65%:wrap'
}

pick_base_branch() {
  list_branches | fzf \
    --prompt 'base branch > ' \
    --header "Repo: $repo_name | Choose the base branch" \
    --layout=default \
    --height=100% \
    --preview "$0 --preview-branch '$repo_root' {}" \
    --preview-window='right:65%:wrap'
}

pick_new_branch_name() {
  base_branch=$1

  result=$(printf '%s\n' "$base_branch" | fzf \
    --prompt 'new branch > ' \
    --header "Repo: $repo_name | Base: $base_branch | Type an existing or new branch name and press Enter" \
    --print-query \
    --phony \
    --layout=default \
    --height=100% \
    --preview "$0 --preview-branch '$repo_root' '$base_branch'" \
    --preview-window='right:65%:wrap') || return 1

  query=$(printf '%s\n' "$result" | sed -n '1p')

  if [ -n "$query" ]; then
    printf '%s\n' "$query"
    return
  fi

  return 1
}

branch_exists() {
  branch=$1
  git show-ref --verify --quiet "refs/heads/$branch" ||
    git show-ref --verify --quiet "refs/remotes/origin/$branch"
}

pick_worktree_to_delete() {
  if ! command -v jq >/dev/null 2>&1; then
    printf 'jq is not installed.\n' >&2
    return 1
  fi

  wt list --format=json \
    | jq -r '.[] | select(.path != null) | [(.branch // "<detached>"), .path, (if .is_current then "current" else "" end)] | @tsv' \
    | fzf \
      --prompt 'delete worktree > ' \
      --header "Repo: $repo_name | Choose a worktree to delete" \
      --delimiter "$(printf '\t')" \
      --with-nth='1,2,3' \
      --layout=default \
      --height=100%
}

if ! command -v wt >/dev/null 2>&1; then
  printf 'wt is not installed.\n'
  pause_and_exit
fi

if ! command -v sesh >/dev/null 2>&1; then
  printf 'sesh is not installed.\n'
  pause_and_exit
fi

if ! command -v fzf >/dev/null 2>&1; then
  printf 'fzf is not installed.\n'
  pause_and_exit
fi

repo_root=$(resolve_repo_root "${1-}")
if [ -z "$repo_root" ]; then
  printf 'Select a git repository first.\n'
  pause_and_exit
fi

cd "$repo_root"
repo_name=$(basename "$repo_root")

action=$(pick_action || true)
[ -n "$action" ] || exit 0

if [ "$action" = 'create' ]; then
  base_branch=$(pick_base_branch || true)
  [ -n "$base_branch" ] || exit 0

  branch=$(pick_new_branch_name "$base_branch" || true)
elif [ "$action" = 'delete' ]; then
  target=$(pick_worktree_to_delete || true)
  [ -n "$target" ] || exit 0

  target_branch=$(printf '%s' "$target" | cut -f1)
  target_path=$(printf '%s' "$target" | cut -f2)

  if [ -n "$target_branch" ] && [ "$target_branch" != '<detached>' ]; then
    exec wt remove -y -f -D "$target_branch"
  fi

  exec wt remove -y -f -D "$target_path"
else
  branch=$(pick_branch_to_switch || true)
fi

[ -n "$branch" ] || exit 0

if [ "$action" = 'create' ]; then
  if branch_exists "$branch"; then
    exec wt switch "$branch" -x "$CONNECT_CMD"
  fi

  exec wt switch --create "$branch" --base "$base_branch" -x "$CONNECT_CMD"
fi

exec wt switch "$branch" -x "$CONNECT_CMD"
