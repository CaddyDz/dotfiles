# MySQL Database management functions
function dumpdb() {
	(mysqldump $1 > $2)
}
function importdb() {
	(mysql $1 < $2)
}
function reset() {
	(mysql -e "drop database $1;create database $1")
}
# Text manipulation functions
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
# Git functions
function remove-merged-branches () {
	currentBranch=$(git rev-parse --abbrev-ref HEAD)

	read -p "Delete branches merges into $currentBranch y/N? " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		git branch --merged | grep -v $currentBranch | while read i; do git branch -d $i; done;
		echo "Branches removed successfully"
	else
		echo "Operation canceled"
	fi
}
# Clone a website into a folder with HTTRACK
function clone() {
	httrack -F "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36" $1 -O $2 -%v -s0
}
