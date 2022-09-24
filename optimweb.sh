#!/bin/sh 

selfpath=`realpath $0`
selfdir=`dirname $selfpath`
selffile=`basename $0`
selfname=${selffile%.*}

source "$selfdir/functions.sh"

recursively="false"
keep_original="false"

while getopts "hrk" arg; do
  case $arg in
    h) # Display help.
      usage $selfname
      exit 0
      ;;
    r) # Keep original image 
      recursively="true"
      shift # It is supposed to be the first / second argument
      ;;
    k) # Keep original image 
      keep_original="true"
      shift # It is supposed to be the first / second argument
      ;;
  esac
done

printf "Searching images...\n"

if [ $# -eq 0 ] # Recursively in the working directory
then 
  get_all_images . $recursively # Return paths in $retval
  optimize_images $retval $keep_original
else
  image_paths=""
  for input in $*
  do  # Multiple arguments or pattern
    if is_image $input  
    then 
      image_paths="$image_paths$input\n"
    else 
      check_dir_exists $input
      get_all_images $input $recursively # Return paths in $retval
      image_paths="$image_paths$retval\n"
    fi
  done 
  optimize_images $image_paths $keep_original 
fi 
