#!/usr/bin/env bash  

# Config

set -euo pipefail
source ./bach.sh
source ./functions.sh

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

