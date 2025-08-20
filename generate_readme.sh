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


buffer="# $(printf $folder | head -c-2)
"

if [[ "$(ls $folder)" == *"md"* ]]; then
  rm $folder/*.md
fi

pictures=$(ls $folder)

for image in $pictures
do
  if [[ "$image" == *"."* ]]; then
    buffer="$buffer
<img src=\"$image\" alt=\"$image\">
"
  fi
done

printf "$buffer" > "${folder}README.md"
