#!/bin/sh
#
# Wallpaper-to-readme generator with sh
#
# https://github.com/dealerofallthecats/walls

run_in_root=false

function print_help() {
  printf "Usage: generate_readme.sh --folder [FOLDER NAME OR PATH]\n"
}

function run_generate() {
  folder=$1

  if [[ $folder == "" ]]; then
    print_help
    exit 1
  fi

  if [[ ! -e $folder ]]; then
    printf "Failed to locate folder: $folder\n"
    exit 1
  fi

  find $folder -not -path '*/.*' -type d | while IFS= read -r dir; do
    if [[ "$dir" == "." ]]; then
      run_in_root=true
      continue
    fi

    if [[ $run_in_root == false ]]; then
      if [[ "${dir: -1}" == "/" ]]; then 
        buffer="# $(printf $dir | head -c-1)\n"
      else
        buffer="# $dir\n"
      fi
    else
      buffer="# $(printf $dir | tail -c+3)"
    fi

    if [[ "$(ls $dir)" == *"md"* ]]; then
      rm $dir/*.md
    fi
 
    pictures=$(ls $dir)
    printf "\n---\nDir: $dir\n---\n$pictures\n---\n"

    for image in $pictures
    do
      if [[ "$image" == *"."* ]]; then
        buffer="$buffer\n<img src=\"$image\" alt=\"$image\">\n"
      fi
    done

    printf "Printing buffer to: ${dir}/README.md\n---\n"
    printf "$buffer" > "${dir}/README.md"
  done
}

case $1 in
--help) print_help ;;
--folder) run_generate $2 ;;
*) print_help ;;
esac
