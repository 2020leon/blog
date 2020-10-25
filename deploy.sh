# If a command fails then the deploy stops
set -e

echo "\033[0;32mDeploying...\033[0m"

# Update date
mdFileCount=$(git status -s | grep -c ".md$" || true)
if [ mdFileCount -gt 1 ]; then
	echo "\033[1;31mError\033[0m: more than one .md file are edited or created"
	exit 1
elif [ mdFileCount -eq 1 ]; then
	echo "\033[0;34m==>\033[0m Updating date..."
	iso8601=$(date +%Y-%m-%dT%H:%M:%S%z)
	iso8601=${iso8601:0:22}:${iso8601:22}
	theFile=$(git status -s | grep ".md$")
	fileStatus=${theFile:0:2}
	theFile=${theFile:3}

	# Update newest date
	if [ $fileStatus = "??" ]; then
		dateLine=$(grep $theFile -e "date" -n  | cut -d : -f 1)
		sed -i '' -e "$dateLine"'c\
		date: '"$iso8601" $theFile
	fi

	# Update newest lastmod
	lastmodLine=$(grep $theFile -e "lastmod" -n  | cut -d : -f 1)
	sed -i '' -e "$lastmodLine"'c\
	lastmod: '"$iso8601" $theFile
fi

# Update themes/meme
echo "\033[0;34m==>\033[0m Updating themes/meme..."
cd themes/meme
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
iso8601=$(date +%Y-%m-%dT%H:%M:%S%z)
iso8601=${iso8601:0:22}:${iso8601:22}
msg="rebuilding site $iso8601"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
echo "\033[0;34m==>\033[0m Pushing source..."
git push origin master