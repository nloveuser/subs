#!/bin/bash
set -e

echo "Generating _config.yml..."

ALL_FILES=$(find . -type f ! -path "./.git/*" ! -path "./.github/*" ! -path "./.gitverse/*" ! -path "./generate_config.sh" ! -path "./encrypt_files.sh" ! -name "_config.yml" ! -name "Gemfile" ! -name "Gemfile.lock" ! -name "last_synced_commit.txt" -exec basename {} \; | sort -u)

INCLUDE_LIST=""
for file in $ALL_FILES; do
  if [[ -n "$file" ]]; then
    escaped_file=$(echo "$file" | sed 's/"/\\"/g')
    if [[ "$INCLUDE_LIST" != "" ]]; then
      INCLUDE_LIST="$INCLUDE_LIST\n  - \"$escaped_file\""
    else
      INCLUDE_LIST="  - \"$escaped_file\""
    fi
  fi
done

cat > _config.yml << EOF
title: "Etoneya"
description: "Сайт Etoneya"
baseurl: ""
url: "https://nloverx.gitverse.site"
include:
$INCLUDE_LIST
exclude:
  - Gemfile
  - Gemfile.lock
  - node_modules
  - vendor
  - .git
  - .gitignore
  - .jekyll-cache
  - .sass-cache
  - .bundle
  - _site
  - README.md
  - LICENSE
permalink: /:basename
trailing_slashes: false
encoding: "utf-8"
defaults:
  - scope:
      path: ""
      type: "pages"
    values:
      layout: null
      permalink: /:basename
      trailing_slashes: false
  - scope:
      path: ""
    values:
      output: true
markdown: kramdown
highlighter: rouge
future: true
unpublished: false
theme: null
plugins: []
safe: true
whitelist: []
lsi: false
EOF

echo "_config.yml generated successfully"
