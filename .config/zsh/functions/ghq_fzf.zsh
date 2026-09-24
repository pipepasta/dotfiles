# Wrap ghq to add custom subcommands; everything else passes through to the real ghq.
#   ghq from [owner]  clone a remote repository selected via fzf
#   ghq cd            cd into a local ghq-managed repository selected via fzf
ghq() {
  case "$1" in
    from)
      local owner="$2"
      local repo
      repo=$(gh repo list "$owner" --limit 300 --json nameWithOwner --jq '.[].nameWithOwner' | fzf) || return
      command ghq get "$repo"
      ;;
    cd)
      local repo
      repo=$(command ghq list | fzf) || return
      builtin cd "$(command ghq root)/$repo"
      ;;
    *)
      command ghq "$@"
      ;;
  esac
}
