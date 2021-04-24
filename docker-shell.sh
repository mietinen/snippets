#!/usr/bin/env bash
# Script to enter bash/sh shell of running Docker Containers
#
# Use with Unraid: place script in /boot/bin/docker-shell.sh
# and add the following lines to /boot/config/go
# cp /boot/bin/docker-shell.sh /usr/local/bin/docker-shell
# chmod +x /usr/local/bin/docker-shell

  
dockers="$(docker ps --format="{{.Names}}")"

i=1
while read -r docker; do
        name["$i"]="$docker"
        echo "[$i]  ${name[$i]}"
        i=$((i+1))
done <<< "$dockers"

echo
echo "Select docker number to spawn bash shell."
read -r number

docker="${name["$number"]}"

if [ -z "$docker" ]; then
        echo "Invalid option"
        exit
fi

for shell in bash sh; do
        echo
        echo "Starting $shell shell on docker image $docker:"
        docker exec -it "$docker" "$shell"
        [ $? -ne 126 ] && break
done
