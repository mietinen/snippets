#!/usr/bin/env bash
#
# Compare file size from find command to a destination folder.
#
# Usage: findcompare <find arguments> <destination>
#   Destination have to be a directory
#   Example: findcompare . -type f -mtime -5 -mindepth 2 -iname *.doc ~/Documents/

dest="${@:$#}"
if [ ! -d "$dest" ]; then
    echo "Usage: $0 <find arguments> <destination>"
    echo "  Destination have to be a directory"
    echo "  Example: $0 . -type f -mtime -5 -mindepth 2 -iname *.doc ~/Documents/"
    exit
fi

find="$(find "${@:1:$#-1}")"

echo "Files found that have size that differs from dest:"
while read -r f; do
    name="${f##*/}"
    size="$(stat --printf="%s" "$f")"
    cfile="$(find "$dest" -iname "$name")"
    if [ -r "$cfile" ]; then
        csize="$(stat --printf="%s" "$cfile")"
        [ "$size" = "$csize" ] && continue
        echo -e "\t$name: $size - $csize"
        echo -e "\t\tcp -p \"$cfile\" \"$f\""
    else
        notfound="$notfound\t$name\n"
    fi
done <<< "$find"

echo
echo "Files not found on dest:"
echo -e "$notfound"
