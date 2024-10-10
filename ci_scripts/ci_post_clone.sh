#!/bin/zsh
#  ci_post_clone.sh

git fetch --tags --deepen 3
if [[ $? -ne 0 ]]; then
echo "Git fetch failed."
exit 1
fi
# Get commit messages from the last tag to the current HEAD
git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"%s" > TestFlight/WhatToTest.en-US.txt
if [[ $? -ne 0 ]]; then
echo "Failed to write commit messages to WhatToTest.en-US.txt."
exit 1
fi
