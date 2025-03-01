#!/bin/bash

echo "$(date +"%H:%M") Replacing image urls.. "

extensions=( "*.md" "*.yml" "*.html" "*.liquid" "*.sass" "*.css" "*.js" "*.json" "*.sql" "*.cql")
cleanup_dirs=( "user-guide" "reference" "edge" "lwm2m")

for ext in "${extensions[@]}"
do
  echo "Replacing the image url in $ext files"
  find . -type f -iname "$ext" -exec sed -i -e '/https/! s/\/images\//https:\/\/img.thingsboard.io\//g' {} \;
  find . -type f -iname "$ext" -exec sed -i -e 's/https:\/\/thingsboard.io\/images\//https:\/\/img.thingsboard.io\//g' {} \;
done

echo "$(date +"%H:%M") Replacing image urls.. done."

echo "$(date +"%H:%M") Uploading images to s3.."
cd images
aws s3 sync . s3://tb-website-images --size-only --quiet
echo "$(date +"%H:%M") Uploading images to s3.. done."

echo "$(date +"%H:%M") Cleanup images.."
for cleanup_dir in "${cleanup_dirs[@]}"
do
  git rm -r $cleanup_dir
done
echo "$(date +"%H:%M") Cleanup images.. done."

cd -

echo "$(date +"%H:%M") Please review changes and commit. "