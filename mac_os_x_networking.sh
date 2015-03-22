#!/bin/bash
# By Soldier of Fortran
# Sets the networking right on MAC OS X Yosemite
# Get z/OS and F0C batches

# This script will be asking for your sudo password. 
# I hope you read the script and know what it's doing.


#Change these to match your setup:
MAC_IP="192.168.1.13"
HERC_IP="192.168.1.200"

## !! Change 'en0' below to your network adapter. Should be fine though !!
MAC_MAC=`ifconfig en0 | grep -Eo '([[:xdigit:]]{1,2}[:-]){5}[[:xdigit:]]{1,2}' | head -n1`


grn=$'\e[1;32m'
end=$'\e[0m'

#
#source: http://www.retrojunkie.com/asciiart/animals/dinos.htm
#
echo $grn

cat <<'EOF'

          /\      ,|
         :  \  /\/ |   _
     .\  |   :: /  | ,' |
     | \ |   ||'/| ;'   |
     :  \:   '// | |    |
     :   \`.//:  ;\;    :
     '    : : | /  `.  /___
      \   | | `' ,   \;'   |
     / `._; . /\      \    ;
    :      / `. \   `  ._,'
    ;      `-.'.',\/`.,:-.
    )   `       '-.\-/ \\__>
    >                `--'  ``---.
   /  .    ,              ,   <o `-.
  :               ,'      `  ______<
  : ,   \    .____..-;``--,-'
   ) -. ,'>-..,-.__,' \.-'(\
  :    : / _ /   \  - :\ _ \\,    . ,
  :  _ | \   )   / _  |:   : `._)_,)/
   )   | :`  |   :    ;| . ).__'_.-'
   :   ) ; _ ;   |   / ; _ ;
   ) - \ `^^^'   ; - \ `^^' SSt
   '^^^`         `^^^'
    Watch out for the ZtegOSaurus
EOF

echo "  [+] Setting up IFCONFIG properlly this time: $MAC_IP --> $HERC_IP"
sudo ifconfig tun0 $MAC_IP $HERC_IP

# from https://github.com/vapier/hercules-390-hyperion/blob/master/README.OSX

echo "  [+] Setting up IP Forwarding on $MAC_IP"
sudo sysctl -w net.inet.ip.forwarding=1

echo "  [+] Setting up ARP forwarding on MAC Address: $MAC_MAC"

## !! Change 'en0' below to your network adapter. Should be fine though !!
sudo arp -s $HERC_IP $MAC_MAC pub en0

echo "  [+] Done! Try pinging $HERC_IP"
echo $end
