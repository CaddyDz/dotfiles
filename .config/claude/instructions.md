# Claude Code Custom Instructions

## Git Commit Message Format

When writing git commit messages:
- Follow conventional commits standard
- Ensure the title does not exceed 50 characters
- Use past tense for subjective verbs
- Use markdown formatting:
  - Single backticks for technical terms (e.g., `variable_name`, `function_name()`)
  - Triple backticks with language specification for code blocks
  - Quotes for error messages (e.g., "Error: connection timeout")
  - Brackets with parentheses for links (e.g., [documentation](https://example.com))
- **Never execute `git add` or `git commit` commands**
- Always copy the git commit message to clipboard using `pbcopy` instead
