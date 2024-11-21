#!/bin/bash

if [[ "$#" -eq 0 ]]; then
	echo "Usage: release.sh VERSION [OPTION]..."
	exit 0
fi

VERSION=${1#v}
VERSION=${VERSION:?Must provide version number.}
shift

git tag v${VERSION} $@
sed -Eie 's#"Version": "[0-9.]+",#"Version": "'"${VERSION}"'",#' package/metadata.json
