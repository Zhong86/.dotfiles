#!/bin/bash

dir="/home/Zhong/Wallpaper"

if [ -n "$1" ]; then
  if [ ! -d "$dir/$1" ]; then
    echo "$1 is not a directory. "
    exit; 
  else 
    echo "Changing wallpaper from $1 directory."
    wallpaper=$(find "$dir/$1" -type f | shuf -n 1)
  fi
else 
  wallpaper=$(find $dir -type f | shuf -n 1)
fi 

plasma-apply-wallpaperimage "$wallpaper" > /dev/null 2>&1
name=$(echo $wallpaper | awk -F'/' '{print $NF}')
echo "Changing wallpaper to $name"

#kde-material-you-colors  &
pid=$!
sleep 3
kill $pid
