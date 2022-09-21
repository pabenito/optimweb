#!/usr/bin/env bash  

# Config

selfpath=`realpath $0`
selfdir=`dirname $selfpath`
source "$selfdir/functions.sh"
source "$selfdir/bach.sh"
set -euo pipefail

# Tests

test-isImageExtension-jpg(){
  is_image_extension "jpg"
  @assert-success
}

test-isImageExtension-jpeg-success(){
  is_image_extension "jpeg"
  @assert-success
}

test-isImageExtension-png-success(){
  is_image_extension "png"
  @assert-success
}

test-isImageExtension-svg-success(){
  is_image_extension "svg"
  @assert-success
}

test-isImageExtension-empty-fail(){
  is_image_extension ""
  @assert-fail
}

test-isImageExtension-pdf-fail(){
  is_image_extension "pdf"
  @assert-fail
}

