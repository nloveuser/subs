#!/bin/bash
set -e

echo "Encrypting files..."

NO_ENCRYPT_FILES="upload_to_s3.py _config.yml index.html CNAME last_synced_commit.txt .gitignore LICENSE README.md robots.txt sitemap.xml Gemfile Gemfile.lock generate_config.sh encrypt_files.sh"
NO_ENCRYPT_DIRS=".git .github .gitverse"

find . -type f | while read -r file; do
  SKIP=false
  filename=$(basename "$file")
  
  for no_encrypt in $NO_ENCRYPT_FILES; do
    if [[ "$filename" == "$no_encrypt" ]]; then
      SKIP=true
      break
    fi
  done
  
  if [[ "$SKIP" == false ]]; then
    for dir in $NO_ENCRYPT_DIRS; do
      if [[ "$file" == *"/$dir/"* ]] || [[ "$file" == "./$dir/"* ]]; then
        SKIP=true
        break
      fi
    done
  fi
  
  if [[ "$SKIP" == false ]]; then
    echo "Encrypting: $file"
    base64 "$file" > "${file}.tmp" && mv "${file}.tmp" "$file"
  fi
done

echo "Encryption complete"
