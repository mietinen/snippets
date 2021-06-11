#!/usr/bin/env bash
# Script to enter bash/sh shell of running Docker Containers
#
# Use with Unraid: place script in /boot/bin/docker-shell.sh
# and add the following lines to /boot/config/go
# cp /boot/bin/docker-shell.sh /usr/local/bin/docker-shell
# chmod +x /usr/local/bin/docker-shell


dockers="$(docker ps --format="{{.Names}}")"

echo "Select docker container to enter in shell"
echo "Exit with CTRL+C"
echo
select docker in $dockers; do
        break
done

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
