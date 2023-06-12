function reset() {
	(mysql -e "drop database $1;create database $1")
}

function splitCsv() {
	HEADER=$(head -1 $1)
	if [ -n "$2" ]; then
		CHUNK=$2
	else
		CHUNK=1000
	fi
	tail -n +2 $1 | split -l $CHUNK - $1_split_
	for i in $1_split_*; do
		sed -i -e "1i$HEADER" "$i"
	done
}

# Remove oh-my-zsh alias
unalias gp
# Register a global function
function gp() {
  # Get the current branch name
  branch=$(git rev-parse --abbrev-ref HEAD)

  # Check if the upstream branch is already set
  if ! git rev-parse --abbrev-ref "@{u}" >/dev/null 2>&1; then
    # Set the upstream branch
    git push --set-upstream origin "$branch"
  fi

  # Push the current branch
  git push
}
