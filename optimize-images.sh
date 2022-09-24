#!/bin/sh 

selfpath=`realpath $0`
selfdir=`dirname $selfpath`
selffile=`basename $0`
selfname=${selffile%.*}

source "$selfdir/functions.sh"

quality=100 # Default quality  

while getopts "hkq:" arg; do
  case $arg in
    h) # Display help.
      usage $selfname
      exit 0
      ;;
    k) # Keep original image 
      keep_original=0
      ;;
    q) # Specify image quality. Must be between 50 and 100
      quality=${OPTARG}
      if [ $quality -lt 50 -o $strength -gt 100 ]
      then 
        printf "Error. Image quality must be between 50 and 100." >&2 
      fi
      ;;
  esac
done

input=${@: -1}
echo $input
if is_image $input  
then 
  image=$input
  printf "$image optimizing...\n"
  optimize_image $image $quality $keep_original
  printf "$image successfully optimized\n"
else 
  get_dir $input 
  get_all_images $retval
  optimize_images $image_paths $quality $keep_original
fi
