#!/usr/bin/env bash
# Remote Real Time Packet Capture With Wireshark and pfsense

ws=(
	"ssh root@192.168.1.41 -p 22 tcpdump -i br0.100 -U -w - "
	"ssh root@192.168.1.41 -p 22 tcpdump -i br0.69 -U -w - "
	"ssh root@192.168.1.187 -p 22 tcpdump -i br0 host not 192.168.1.2 -U -w - "
)

if [ -z "$1" ] || [ -z "${ws["$1"]}" ]; then
	echo "Usage $(basename "$0") <number>"
	for key in "${!ws[@]}"; do
		echo "$key: wireshark -k -i <(${ws["$key"]})"
	done
else
	wireshark -k -i <(${ws["$1"]})
fi
