# Claude Code look: orange ✻ spark, muted path, ❯ prompt
# Layout follows the built-in "cloud" theme.
CLAUDE_ORANGE='%F{173}'
CLAUDE_MUTED='%F{245}'

PROMPT='${CLAUDE_ORANGE}%B✻%b%f ${CLAUDE_MUTED}%c%f $(git_prompt_info)%(?.${CLAUDE_ORANGE}.%F{red})❯%f '

ZSH_THEME_GIT_PROMPT_PREFIX="%F{180}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{180}) %F{yellow}●"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{180})"
