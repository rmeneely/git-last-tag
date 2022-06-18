#!/bin/bash
# Description: Utility to return the most recent matching tag
program=`basename $0`
Syntax='$program [-t <tag pattern>]'
set -e

# Defaults
export TAG_PATTERN="${INPUT_TAG_PATTERN:-'v[0-9]*.[0-9]*.[0-9]*'}"

# Add this git workspace as a safe directory
# Required by GitHub Actions to enable this action to execute git commands
if [ "${GITHUB_WORKSPACE}" !=  '' ]; then
   git config --global --add safe.directory "$GITHUB_WORKSPACE"
fi

# Get command line arguments
while getopts "t:h" option; do
  case $option in
    t) # Tag pattern
       TAG_PATTERN=$OPTARG ;;
    h) # Help
       echo "Syntax: ${Syntax}"
       echo "Defaults:"
       echo "Tag Pattern: ${TAG_PATTERN}"
       exit 0
       ;;
    \?) # Invalid option
       echo "Error: Invalid option" >&2
       echo "Syntax: ${Syntax}" >&2
       exit 1
       ;;
  esac
done

display_options() {
  echo "TAG_PATTERN=$TAG_PATTERN"
  echo ""
}

sanitize_parameters() {
  # Cleanup of input parameter format
  TAG_PATTERN=`echo "$TAG_PATTERN" | sed -e "s/^'//" -e "s/'$//"`
  TAG_PATTERN="'$TAG_PATTERN'"
}

function get_last_tag() { # Get most recent matching tag
  pattern="${1:-${TAG_PATTERN}}"
  git fetch --tags
  cmd="git tag --sort=committerdate --list ${pattern} | tail -1"
  eval $cmd
}

function main() { # main function
  sanitize_parameters

  # Get the last tag 
  LAST_TAG=`get_last_tag "${TAG_PATTERN}"`
  
  # Output the versions
  if [ "${GITHUB_ENV}" !=  '' ]; then
     echo "LAST_TAG=${LAST_TAG}" >> $GITHUB_ENV
     echo "::set-output name=last_tag::${LAST_TAG}"
  else
     echo "LAST_TAG=${LAST_TAG}"
  fi
}

# Main
main

exit $?

# EOF: last_tag.sh
