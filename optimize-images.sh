#!/bin/sh 

selfpath=`realpath $0`
selfdir=`dirname $selfpath`
source "$selfdir/functions.sh"

if [[ $* == *--keep* ]]
then 
  keep_original=0
fi

if is_image $1 
then 
  image=$1
  printf "$image optimizing...\n"
  optimize_image $image $keep_original
  printf "$image successfully optimized\n"
else 
  get_dir $1
  get_all_images $dir
  optimize_images $image_paths $keep_original
fi


