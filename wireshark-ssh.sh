#!/usr/bin/env bash
# Remote Real Time Packet Capture With Wireshark and pfsense

ssh=(
    "ssh root@192.168.1.1 -p 22 tcpdump -i igb0 -U -w - "
    "ssh root@192.168.1.1 -p 22 tcpdump -i igb1.999 -U -w - "
    "ssh root@192.168.1.1 -p 22 tcpdump -i igb0 host not 192.168.1.2 -U -w - "
)

echo "Wireshark remote packet capture with pfsense"
echo "Exit with CTRL+C"
echo
select ws in "${ssh[@]}"; do
        break
done

if [ -z "$ws" ]; then
        echo "Invalid option"
        exit
fi

wireshark -k -i <($ws)

# vim: set ts=4 sw=4 tw=0 et :
