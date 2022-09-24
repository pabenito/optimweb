#!/bin/sh 
usage(){
  command=$1
  printf "$command [OPTION] [INPUT]\n\n"
  printf "[OPTION]:\n\t[-h]\tShow help.\n\t[-k]\tKeep original images\n\t[-q quality]\tSet image quality. Must be between 50 and 100.\n\n"
  printf "[INPUT]: There are some posible inputs\n\t[Image]\tA single image.\n\t[Pattern]\tA pattern matching some images, i.e. team*\n\t[Directory]\tA directory. If not specified the directory is the working directory.\n"
}

optimize_image(){
  local path=$1
  local quality=$2
  local keep_original=$3
  local ext="${path##*.}"
  if [[ $keep_original = 0 ]] && [[ $ext = "jpg" ]]
  then 
    local outupt="${path%.*}-optimized.jpg"
    cp $path $outupt 
    path=$outupt
  fi 
  mogrify -format jpg -sampling-factor 4:2:0 -strip -quality $quality -interlace line -colorspace RGB $path  
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
  local quality=$2
  local keep_original=$3
  
  count_lines $image_paths
  local num_of_images=$?
  local image_paths=`printf $image_paths`

  IFS_original=$IFS
  IFS=$'\n'
  
  local i=1
  for path in $image_paths
  do 
    printf "[$i/$num_of_images] $path\n"
    optimize_image $path $quality $keep_original
    local i=$((i+1))
  done
  
  IFS=$IFS_original
}
