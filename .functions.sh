function splitCsv() {
	HEADER=$(head -1 "$1")
	CHUNK=${2:-1000}
	tail -n +2 "$1" | split -l "$CHUNK" - "$1_split_"
	# Prepend the header portably (`sed -i -e "1i…"` is GNU-only)
	for i in "$1"_split_*; do
		{ printf '%s\n' "$HEADER"; cat "$i"; } > "$i.tmp" && mv "$i.tmp" "$i"
	done
}

# Remove oh-my-zsh alias
unalias gp 2>/dev/null
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

function remove-merged-branches () {
	currentBranch=$(git rev-parse --abbrev-ref HEAD)

	read -q "REPLY?Delete branches merged into $currentBranch y/N? "
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		git branch --merged | grep -v $currentBranch | while read i; do git branch -d $i; done;
		echo "Branches removed successfully"
	else
		echo "Operation canceled"
	fi
}

# Pop this branch's newest stash rather than the newest one overall
function pop() {
	local branch ref
	branch=$(git rev-parse --abbrev-ref HEAD) || return
	ref=$(git stash list --format='%gd%x09%gs' | awk -F '\t' -v b="$branch" \
		'index($2, "WIP on " b ":") == 1 || index($2, "On " b ":") == 1 { print $1; exit }')
	if [[ -z $ref ]]; then
		echo "No stash for $branch" >&2
		return 1
	fi
	git stash pop "$ref"
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

# Legacy `port`: sums character codes, so anagrams collide. Kept because
# FraudCentral (50427), Roboguard/Sockets (50117), Roboguard -> Control (49921)
# and xeldex (49802) hardcode values it generated.
port_legacy() {
	local word=$1 sum=0 i
	for (( i=0; i<${#word}; i++ )); do
		(( sum += $(printf "%d" "'${word:$i:1}") ))
	done
	echo $(( 49152 + sum % 16384 ))
}

# Warn on stderr if a port is listening locally, published by a running
# container, or written in a docker-compose*.yml/.env under ~/Code
_port_check() {
	local p=$1 hits
	if lsof -nP -iTCP:"$p" -sTCP:LISTEN -t >/dev/null 2>&1; then
		echo "port $p: listening on this Mac" >&2
	fi
	hits=$(docker ps --format '{{.Names}} {{.Ports}}' 2>/dev/null | grep -F ":$p->" | cut -d' ' -f1)
	[[ -n $hits ]] && echo "port $p: published by container(s): ${hits//$'\n'/, }" >&2
	hits=$(grep -rlE "(^|[^0-9])$p([^0-9]|$)" --include='docker-compose*.yml' --include='.env' \
		--exclude-dir={node_modules,vendor,.git} ~/Code 2>/dev/null)
	[[ -n $hits ]] && echo "port $p: found in\n${hits//$HOME/~}" >&2
	return 0
}

# Hash a string (e.g. a project name) into a port in 49152-65535
# Usage: port [--check] <string>
port() {
	local check=0 word
	[[ $1 == --check ]] && { check=1; shift; }
	word=$1
	if [[ -z $word ]]; then
		echo "usage: port [--check] <string>" >&2
		return 1
	fi

	local crc len p
	read -r crc len < <(printf %s "$word" | cksum)
	p=$(( 49152 + crc % 16384 ))

	(( check )) && _port_check $p
	echo $p
}
