# MySQL Database management functions
function dumpdb() {
	(mysqldump $1 > $2)
}
function importdb() {
	(mysql $1 < $2)
}
function resetdb() {
	(mysql -e "drop database $1;create database $1")
}
# Text manipulation functions
function splitCsv() {
	HEADER=$(head -1 "$1")
	CHUNK=${2:-1000}
	tail -n +2 "$1" | split -l "$CHUNK" - "$1_split_"
	# Prepend the header portably (`sed -i -e "1i…"` is GNU-only)
	for i in "$1"_split_*; do
		{ printf '%s\n' "$HEADER"; cat "$i"; } > "$i.tmp" && mv "$i.tmp" "$i"
	done
}
# Git functions
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
# Push the current branch, setting its upstream on the first push
unalias gp 2>/dev/null
function gp() {
	branch=$(git rev-parse --abbrev-ref HEAD)
	if ! git rev-parse --abbrev-ref "@{u}" >/dev/null 2>&1; then
		git push --set-upstream origin "$branch"
	fi
	git push
}
# Clone a website into a folder with HTTRACK
function clone() {
	httrack -F "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36" $1 -O $2 -%v -s0
}
