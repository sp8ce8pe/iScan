#!/usr/bin/bash

# Syntax: ./iscan.sh <ip_address> <ip_address> ...etc

# To do:
# - UDP scan top 20 (after all TCP scans)
# - make open_ports variable...
# - clean up script to make it less shitty.... more elegant...

# Print syntax if no arguments given: $# means , 0 means "if everything goes fine"
if [ $# -eq 0 ]
then
	# >&2 means send the output to STDERR - i.e. "print the message as an error on the console"
    >&2 echo -e "\nSyntax: ./iscan.sh <IP_ADDRESS> <IP_ADDRESS> <...>"
    exit 1  #what does this ACTUALLY do?
else

echo "
                           10-Mar-2023 / version 1
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                           #
# iScan (\"inital scan\") - a quick, shit, quick shit, no fluff inital scan   #
#                                                                           #
#                 >>>>>-------------------> by sp8ce8pe, resident dickbutt  #
#                                                                           #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
"

for ip in "$@"  # "$@" = "for all the arguments given to the script"
do
	mkdir -p ./$ip/{loot,access,privesc}
	# retarded... get ports into working variable $open_ports / use sed/awk instead of cut? / remove comma at end of last port in list
	sudo nmap -Pn -p0- --open $ip | grep open | cut -d "/" -f 1 | tr "\n" ", " > ./$ip/$ip.ports
	# implement tee here, ingest $open_ports variable here to complete scan
	sudo nmap -Pn -A -p $(cat ./$ip/$ip.ports) $ip > ./$ip/$ip.nmap
	sudo chown kali:kali ./$ip/*
	echo -e "\nNmap scan for $ip complete with open ports..."  #list open ports when $open_ports variable is made...
	rm ./$ip/$ip.ports
done
fi