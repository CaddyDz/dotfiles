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

function deleteClosedIssues() {
	gh issue list --state closed
	for issue in $(gh issue list --state closed --json number -q '.[].number'); do
		gh issue delete $issue --yes
	done
}

function handleDependabot() {
	# List of all CI job names
	CI_JOBS=("triage" "style" "laravel-tests")

	# Check all pull requests for the current repository
	for pr in $(gh pr list --json number --jq '.[] | .number'); do
		all_passed=true

		# Fetch the status of checks for the PR and store in a temporary file
		gh pr checks $pr > /tmp/gh_checks_$pr.txt

		# Check status for each CI job
		for ci_job in "${CI_JOBS[@]}"; do
			# Fetch the status of checks for the PR from the first line
			ci_status=$(cat /tmp/gh_checks_$pr.txt | grep "$ci_job" | awk '{print $2}')
			if [[ "$ci_status" != "pass" ]]; then
			all_passed=false
			break
			fi
		done

		# Clean up the temporary file
		rm /tmp/gh_checks_$pr.txt

		# If all CI jobs have passed, approve and comment
		if $all_passed; then
			gh pr review $pr --approve
			gh pr comment $pr --body "@dependabot merge"
		else
			# Request changes if any CI job has failed
			gh pr review $pr --request-changes --body "@dependabot recreate"
		fi
	done
}

port() {
    word=$1
    
    # Simple hash: Sum ASCII values of characters
    sum=0
    for (( i=0; i<${#word}; i++ )); do
        char=${word:$i:1}
        ascii=$(printf "%d" "'$char")
        ((sum+=ascii))
    done
    
    # Define port range for dynamic/private ports
    min_port=49152
    max_port=65535
    port_range=$((max_port - min_port + 1))
    
    # Calculate port number
    port=$((min_port + (sum % port_range)))
    
    echo $port
}

# Prevent brew upgrade commands
brew() {
  local command="$1"
  shift

  if [[ "$command" == "upgrade" ]] || [[ "$command" == "update" && "$*" == *"--greedy"* ]] || [[ "$command" == "update" && "$*" == *"upgrade"* ]]; then
    echo "⛔️ BREW UPGRADE BLOCKED: This command has been disabled to prevent breaking your system, it will break Postgres & Meilisearch and you will waste a lot of time fixing them."
    echo "If you really need to upgrade packages, use 'command brew $command $*' to bypass this protection."
    return 1
  else
    command brew "$command" "$@"
  fi
}