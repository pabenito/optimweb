# Optimweb (optimize-images-web) 

Command line tool to optimize images for web, individually, searching by pattern or an entire folder.

## Dependencies

- jpegoptim
- imagemagick (Can be replaced by any other tool that can convert images to JPG format)

## Usage

`optimweb [OPTION] [INPUT]*`

**Note**: the '*' symbol mean as many _inputs_ you want.

### Options

#### Help 

Shows help.

`optimweb -h`

#### Keep original

Keep original images. 

`optimweb -k [INPUT]*`

### Recursive

Optimeze images recursively in the specified directories.

`optimweb -r [INPUT]*`

### Inputs

#### Individually

`optimweb image1.png image2.jpg`

#### Directory

`optimweb dir`

Self directory do not need to be specified when is alone. 

`optimweb .` = `optimweb`

#### Patterns 

`optimweb Dowloads/**.png`

#### Mixed

`optimweb . Dowloads/image1.png dir1 image2.jpg`

`optimweb -r Documents/dir1 image1.png dir2`

**Warning**: The last one search recursively in 'Documents/dir1' and in 'dir2' also.  
