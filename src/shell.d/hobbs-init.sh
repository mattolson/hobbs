# Link instance-level skills into a location Claude Code can discover.
# ~/.hobbs/skills/ is not in the directory tree Claude Code walks from the
# working directory, so we symlink it into the workspace-level .claude/skills/.
if [ -d "$HOME/.hobbs/skills" ] && [ ! -e "$HOME/hobbs/workspace/.claude/skills" ]; then
  mkdir -p "$HOME/hobbs/workspace/.claude"
  ln -s "$HOME/.hobbs/skills" "$HOME/hobbs/workspace/.claude/skills"
fi
