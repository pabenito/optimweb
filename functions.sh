#!/bin/sh 

optimize_image()
{
  local path=$1
  local keep_original=$2
  local ext="${path##*.}"
  if [[ $keep_original = 0 ]] && [[ $ext = "jpg" ]]
  then 
    local outupt="${path%.*}-optimized.jpg"
    cp $path $outupt 
    path=$outupt
  fi 
  mogrify -format jpg -sampling-factor 4:2:0 -strip -quality 85 -interlace line -colorspace RGB $path  
  if ! [[ $keep_original = 0 ]] && ! [[ $ext = "jpg" ]]
  then rm $path 
  fi 
}

count_lines(){
  return `printf "$1" | wc --lines`
}

is_image_extension(){
  local ext=$1
  if [ $ext = "jpg" ] || [ $ext = "jpeg" ] ||[ $ext = "png" ] ||[ $ext = "svg" ]
  then return 0 
  else return 1
  fi 
}

is_image(){
  local path=$1
  local ext="${path##*.}"
  if ! [ -z $path ] && [ -f $path ] && is_image_extension $ext
  then return 0
  else return 1
  fi
}

get_dir(){
  dir=$1
  
  if [ -z $dir ]
  then 
    dir="."
  fi
  
  if [ ! -d $dir ]
  then 
    printf "Error: The specified directory '$dir' does not exist\n" >&2
    exit 1
  fi
}

get_all_images(){
  local dir=$1
  image_paths=""
  printf "Searching images...\n"

  for path in `find $dir -print`
  do 
    if is_image $path
    then 
      image_paths+="$path\n"  
    fi
  done
 
  count_lines $image_paths
  local num_of_images=$?
  if [ $num_of_images -le 0 ]
  then
    printf "There are no images in the specified directory '$dir'\n"
    exit 0
  fi
}

optimize_images(){
  local image_paths=$1
  count_lines $image_paths
  local num_of_images=$?
  local image_paths=`printf $image_paths`

  IFS_original=$IFS
  IFS=$'\n'
  
  local i=1
  for path in $image_paths
  do 
    printf "[$i/$num_of_images] $path\n"
    optimize_image $path $keep_original
    local i=$((i+1))
  done
  
  IFS=$IFS_original
}
