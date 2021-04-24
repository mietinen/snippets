#!/bin/bash
# Small scripts to enter all directories (maxdepth 1)
# and extract rar archives, with no overwrite (-o-)

pwd="$(pwd)"
folders="$(find "$(pwd)" -maxdepth 1 -type d)"
echo > "$pwd/unrarall.log"

while read -r folder; do
	[ "$folder" = "$pwd" ] && continue 
	cd "$folder"
	rarfile="$(find . -maxdepth 1 -iname '*.rar' | head -1)"
	[ ! -r "$rarfile" ] && continue
	unrar x -o- "$rarfile" | tee -a "$pwd/unrarall.log"
done <<< $folders

cd "$pwd"
