# If a command fails then the deploy stops
set -e

echo "\033[0;32mDeploying...\033[0m"

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
iso8601=$(date +%Y-%m-%dT%H:%M:%S%z)
iso8601=${iso8601:0:22}:${iso8601:22:24}
msg="rebuilding site $iso8601"
if [ -n "$*" ]; then
	msg="$*"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master