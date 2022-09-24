#!/bin/sh 
usage(){
  command=$1
  printf "$command [OPTION] [INPUT]*\n\n"
  printf "[OPTION]:\n\t[-h]\tShow help.\n\t[-b]\tBack up original images.\n"
  printf "[INPUT]: There are some posible inputs\n\t[Image]\tA single image.\n\t[Pattern]\tA pattern matching some images, i.e. team*\n\t[Directory]\tA directory. If not specified the directory is the working directory.\n"
}

optimize_image(){
  local path=$1
  local keep_original=$2
  
  local ext="${path##*.}"
  local path_without_ext=${path%.*}
  local path_jpg="$path_without_ext.jpg"

  if [ $keep_original = "true" ] && [ $ext = "jpg" ]
  then 
    cp $path "${path_without_ext}_original.jpg" 
  fi 
  
  if ! [ $ext = "jpg" ]
  then 
    convert $path $path_jpg # Imagemagick command 
  fi 

  jpegoptim --quiet --all-progressive --strip-all $path_jpg 

  if [ $keep_original = "false" ] && [ $ext != "jpg" ]
  then 
    rm $path 
  fi
}

count_lines(){
  return `printf "$1" | wc --lines`
}

is_image_extension(){
  local ext=$1
  if [ $ext = "jpg" ] || [ $ext = "jpeg" ] ||[ $ext = "png" ] || [ $ext = "svg" ]
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

check_dir_exists(){
  dir=$1
  if [ ! -d $dir ]
  then 
    printf "Error: The specified directory '$dir' does not exist\n" >&2
    exit 1
  fi
}

get_all_images(){
  local dir=$1
  local recursively=$2

  local image_paths=""
  local element_paths=""
  
  IFS_original=$IFS
  IFS=$'\n'

  if [ $recursively = "true" ]
  then 
    element_paths=`find $dir -print`
  else 
    element_paths=`ls -1 $dir`
  fi
  
  for element in $element_paths 
  do
    if is_image $element
    then 
      image_paths+="$element\n"  
    fi 
  done

  IFS=$IFS_original 

  count_lines $image_paths
  local num_of_images=$?
  if [ $num_of_images -le 0 ]
  then
    printf "There are no images in the specified directory '$dir'\n"
    exit 0
  fi

  retval=$image_paths
}

optimize_images(){
  local image_paths=$1
  local keep_original=$2
  
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
