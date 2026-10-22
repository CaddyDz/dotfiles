# Commits and pull requests

These apply in every repository, on every machine. They override Claude Code's default attribution.

## Commits

- Commit with the repository's git identity (`user.name`, `user.email`), which is mine. Never pass `--author`. If no identity is set, ask me which one to use.
- Never add a `Co-Authored-By: Claude …` trailer, a `Claude-Session` link, or any other line crediting Claude or Claude Code.
- Follow the repository's own conventions, such as `Signed-off-by` (`git commit -s`) where its history uses it.

## Pull requests

Set all of these in the `gh pr create` call itself, not in a follow-up edit:

- **Assignee:** me (`--assignee @me`).
- **Labels:** one or more from the repository's own labels (`gh label list`). If none fits, use the closest and tell me.
- **Milestone:** always. Reuse an open milestone that fits (`gh api repos/{owner}/{repo}/milestones`). If none does, create one without asking (`gh api repos/{owner}/{repo}/milestones -f title=… -f description=…`). Name it for the body of work the PR belongs to, such as a feature area or a release, so later PRs can share it. Never one per PR.
- **Related issues:** search the repository's issues first. Write `Closes #N` for an issue the PR resolves and `Refs #N` for one it only relates to.
- Never add the `🤖 Generated with [Claude Code]` line, or any other line crediting Claude.

If a repository won't let me set one of these (no permission, or not on GitHub), use the host's equivalent or say so in the summary. Never skip it silently.
