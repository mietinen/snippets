#!/usr/bin/env bash
# Test multiple http/https connections, sort by time to load

urls=(
    https://www.youtube.com
    https://www.twitch.com
    https://www.reddit.com
)

echo "Test multiple http(s) connections, sort by time to load"
echo

output=""
for h in "${urls[@]}"; do
    time=$(curl -Lo /dev/null --connect-timeout 5 -s -w "%{time_connect} %{time_starttransfer} %{time_total}" "$h")
    if [ $? -eq 0 ] ; then
        output="${output:+${output}\n}$h $time"
    else
        output="${output:+${output}\n}$h FAILED FAILED FAILED"
    fi
done
(echo "URL Connect Start Total" ; (echo -e "$output" | sort -k4)) | column -t

# vim: set ts=4 sw=4 tw=0 et :
