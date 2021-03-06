#!/bin/sh

set -e

if [ $# -ne 1 ]; then
  echo "Usage: ./build-ckeditor.sh CKEDITOR_VERSION"
  exit 1
fi

VERSION=$1

# Make sure submodule is registered and up-to-date.
git submodule update --init

# Fetch remote changes.
cd ckeditor-dev
git fetch

# Make sure our working copy is clean.
git reset --hard HEAD
git clean -fdx

# Checkout desired target version.
git checkout "$VERSION"

# Make the debug or release build.
if [ -n "$DEBUG" ]; then
	dev/builder/build.sh --build-config ../../../build-config.js --leave-css-unminified --leave-js-unminified
else
	dev/builder/build.sh --build-config ../../../build-config.js
fi

# Remove old build files.
rm -rf ../ckeditor/*

# Replace with new build files.
cp -r dev/builder/release/ckeditor/* ../ckeditor/

echo
echo "*---------------------------------------------------------*"
echo "|                          DONE                           |"
echo "*---------------------------------------------------------*"
echo
echo
echo "Don't forget to commit the result!"
echo
echo "    git add -A -- ckeditor"
echo "    git commit -m 'Update CKEDITOR to $VERSION'"
echo
