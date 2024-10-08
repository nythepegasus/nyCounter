#!/bin/zsh
#  ci_post_xcodebuild.sh

if [[ -d "$CI_APP_STORE_SIGNED_APP_PATH" ]]; then
  TESTFLIGHT_DIR_PATH="$CI_WORKSPACE_PATH/TestFlight"
  mkdir -p $TESTFLIGHT_DIR_PATH
  git fetch --tags --deepen 3
  if [[ $? -ne 0 ]]; then
    echo "Git fetch failed."
    exit 1
  fi
  # Get commit messages from the last tag to the current HEAD
  git log $(git describe --tags --abbrev=0)..HEAD --pretty=format:"%s" > $TESTFLIGHT_DIR_PATH/WhatToTest.en-US.txt
  if [[ $? -ne 0 ]]; then
    echo "Failed to write commit messages to WhatToTest.en-US.txt."
    exit 1
  fi
else
  echo "Signed app not found at $CI_APP_STORE_SIGNED_APP_PATH."
  exit 1
fi

