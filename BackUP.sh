#!/bin/bash

# validate wheather the path is valid or not 
function validateDirectory(){
  if ! test -d "$1";then
    return 1
  fi
  return 0
}

function main(){
# input - file which contians all the paths of folder to be copied
  read -p "enter the input file :" input
  if ! test -f "$input";then
    echo "no such file exist in the path : $input"
    exit 1
  fi

# destination - path of destination folder where we need to copy all the folders
  read -p "enter the destination folder path:" destination

  validateDirectory "$destination"
  exit_status=$?
  until [ "$exit_status" -eq 0 ];
  do
    echo "$destination folder dosnot exists !!!"
    read -p "Do you want to create the destination folder in this location : $destination ?(Y/N)" decision
    if [[ "$decision" == 'Y' || "$decision" == 'y' ]]; then
      mkdir "$destination"
      break
    fi
    read -p "Enter the valid destination directory path : " destination
    validateDirectory "$destination"
    exit_status=$?
  done

  echo "BackUP started at $(date) : "

  while IFS= read -r line;do
      if [[ -z "$line" ]]; then
        continue
      fi

      validateDirectory "$line"
      if [[ $? -ne 0 ]]; then
        echo "skipping : $line does not exist"
        continue
      fi
      time="$(date "+%Y%m%d_%H%M%S")"
      dest_dir="${destination}/$(basename "$line")_backup-$time"
      mkdir -p "$dest_dir"
      cp -r "${line}"/* "$dest_dir"
  done < "$input"
  echo "BackUP compleated at $(date) : "

}

main
