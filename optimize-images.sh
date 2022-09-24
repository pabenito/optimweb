#!/bin/sh 

selfpath=`realpath $0`
selfdir=`dirname $selfpath`
selffile=`basename $0`
selfname=${selffile%.*}

source "$selfdir/functions.sh"

back_up="false"

while getopts "hb" arg; do
  case $arg in
    h) # Display help.
      usage $selfname
      exit 0
      ;;
    b) # Back up original image 
      back_up="true"
      shift # It is supposed to be the first argument
      ;;
  esac
done

if [ $# -eq 0 ] # Recursively in the working directory
then 
  get_all_images . # Return paths in $retval
  optimize_images $retval $back_up
fi

printf "Searching images...\n"
image_paths=""
for input in $*
do  # Multiple arguments or pattern
  if is_image $input  
  then 
    image_paths="$image_paths$input\n"
  else 
    check_dir_exists $input
    get_all_images $input # Return paths in $retval
    image_paths="$image_paths$retval\n"
  fi
done 

optimize_images $image_paths $back_up
