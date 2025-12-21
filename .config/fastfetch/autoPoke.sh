#!/bin/bash

text="/home/Zhong/.config/fastfetch/list.txt"
readarray -t list < <(awk -F',' '{ for(i=1; i<NF; i++) print $i }' $text)

arrLen=${#list[@]}
ran=$(( RANDOM % arrLen ))
ranPoke=$(echo "${list[ran]}")


readarray -t pokecmd < <(awk -v str="$ranPoke" 'BEGIN{split(str, a, "_"); for(i in a) print a[i]}')
pokeLen=${#pokecmd[@]}
name=${pokecmd[0]}
shiny=0
form=""
if [[ $pokeLen > 1 ]]; then
  #checks if shinys
  for ((i = 1; i < $pokeLen; i++)); do
    if [[ ${pokecmd[i]} == "s" ]]; then
      shiny=1
    else
      form="${pokecmd[i]}"
    fi
  done
fi

if [[ $shiny -eq 1 ]]; then
  if [[ -n $form ]]; then
    pokemon-colorscripts -s -n $name -f $form --no-title > /home/Zhong/.config/fastfetch/logo.txt
  else
    pokemon-colorscripts -s -n $name --no-title > /home/Zhong/.config/fastfetch/logo.txt
  fi
else
  if [[ -n $form ]]; then
    pokemon-colorscripts -n $name -f $form --no-title > /home/Zhong/.config/fastfetch/logo.txt
  else
    pokemon-colorscripts -n $name --no-title > /home/Zhong/.config/fastfetch/logo.txt
  fi
fi

