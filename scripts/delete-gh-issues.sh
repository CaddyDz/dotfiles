#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Set the author variable to the first command line argument or default to "CaddyDz"
author=${1:-CaddyDz}

echo -e "${YELLOW}Fetching issues created by '${author}'...${NC}"

# Attempt to fetch issues and capture any error output
error_output=$(gh issue list --state all --json number,author --jq '.[] | select(.author.login == "'"$author"'") | .number' 2>&1)
if [[ $? -ne 0 ]]; then
	echo -e "${RED}${error_output}${NC}"
	echo -e "${GREEN}Completed deleting issues created by '${author}'.${NC}"
	exit 1
fi

# List all issues and filter by the author, then delete each issue
for issue_number in ${error_output}
do
	echo -e "${YELLOW}Deleting issue #${issue_number}...${NC}"
	# Delete the issue with the specified issue number
	if gh issue delete $issue_number --yes; then
		echo -e "${GREEN}Issue #${issue_number} deleted.${NC}"
	else
		echo -e "${RED}Failed to delete issue #${issue_number}.${NC}"
	fi
done

echo -e "${GREEN}Completed deleting issues created by '${author}'.${NC}"
