#!/bin/sh

function print_help() {
  printf "Usage: generate_readme.sh [FOLDER NAME OR PATH]\n"
}

folder=$1

if [[ $folder == "" ]]; then
  print_help
  exit 1
fi

if [[ ! -e $folder ]]; then
  printf "Failed to locate folder: $folder\n"
  exit 1
fi

folder=$(printf $folder | tr -d '/\\')

buffer="# $folder
"

if [[ "$(ls $folder)" == *"md"* ]]; then
  rm $folder/*.md
fi

pictures=$(ls $folder)

for image in $pictures
do
  buffer="$buffer
<img src=\"$image\" alt=\"$image\">
"
done

printf "$buffer" > "$folder/README.md"
