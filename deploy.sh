# If a command fails then the deploy stops
set -e

echo "\033[0;32mDeploying...\033[0m"

# Update date
echo "\033[0;34m==>\033[0m Updating date..."
fileCount=$(git status -s | wc -l)
if [ $fileCount -gt 1 ]; then
	echo "\033[1;31mError\033[0m: more than one file are edited or created"
	exit 1
fi
iso8601=$(date +%Y-%m-%dT%H:%M:%S%z)
iso8601=${iso8601:0:22}:${iso8601:22}
theFile=$(git status -s)
fileStatus=${theFile:0:2}
theFile=${theFile:3}
dateLine=$(grep $theFile -e "date" -n  | cut -d : -f 1)
lastmodLine=$(grep $theFile -e "lastmod" -n  | cut -d : -f 1)

# Update newest date
if [ $fileStatus = "??" ]; then
	sed -i '' -e "$dateLine"'c\
	date: '"$iso8601" $theFile
fi

# Update newest lastmod
sed -i '' -e "$lastmodLine"'c\
lastmod: '"$iso8601" $theFile

# Update themes/axiom
echo "\033[0;34m==>\033[0m Updating themes/axiom..."
cd themes/axiom
git pull
cd ../..

# Build the project.
echo "\033[0;34m==>\033[0m Building the project..."
hugo --minify # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
echo "\033[0;34m==>\033[0m Commiting changes..."
msg="rebuilding site $iso8601"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
echo "\033[0;34m==>\033[0m Pushing source..."
git push origin master