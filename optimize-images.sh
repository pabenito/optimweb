#!/bin/sh 

selfpath=`realpath $0`
selfdir=`dirname $selfpath`
selffile=`basename $0`
selfname=${selffile%.*}

source "$selfdir/functions.sh"

back_up="false"

while getopts "hk" arg; do
  case $arg in
    h) # Display help.
      usage $selfname
      exit 0
      ;;
    b) # Back up original image 
      back_up="true"
      ;;
  esac
done

input=${@: -1}
if is_image $input  
then 
  image=$input
  optimize_image $image $back_up
  printf "$image successfully optimized\n"
else 
  get_dir $input # Return dir in $retval
  get_all_images $retval
  optimize_images $image_paths $back_up
fi
