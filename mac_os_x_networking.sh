#!/bin/bash
# By Soldier of Fortran
# Sets the networking right on MAC OS X Yosemite
# F*ck batches, get mainframes

# This script will be asking for your sudo password. 
# I hope you read the script and know what it's doing
# Instead of just typing it in.


#Change these to match your setup:
MAC_IP="192.168.1.13"
HERC_IP="192.168.1.200"

## !! Change 'en0' below to your network adapter. Should be fine though !!
MAC_MAC=`ifconfig en0 | grep -Eo '([[:xdigit:]]{1,2}[:-]){5}[[:xdigit:]]{1,2}' | head -n1`


grn=$'\e[1;32m'
end=$'\e[0m'
red=$'\e[1;31m'
mag=$'\e[1;35m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
cyn=$'\e[1;36m'

###
#Source: http://www.retrojunkie.com/asciiart/animals/dinos.htm
###
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
   ) - \ `^^^'   ; - \ `^^' 
   '^^^`         `^^^'
   Watch out for the ZtegOSaurus

EOF

# From: Hours of screwing around getting this to work
echo "  [+] Setting up IFCONFIG properlly this time: $MAC_IP --> $HERC_IP"
sudo ifconfig tun0 $MAC_IP $HERC_IP

#From: https://github.com/vapier/hercules-390-hyperion/blob/master/README.OSX
echo "  [+] Setting up IP Forwarding on $MAC_IP"
sudo sysctl -w net.inet.ip.forwarding=1 >/dev/null
echo "  [+] Setting up ARP on MAC Address: $MAC_MAC"
sudo arp -s $HERC_IP $MAC_MAC pub en0 >/dev/null

#Okay, now check the machine is up
ping -c 1 $HERC_IP &>/dev/null
if [ $? -ne 0 ] ; then
   echo "$red  [!] $HERC_IP isn't pingable.$yel You did something wrong!"
   echo $grn
   echo "      Did you IPL the system already? Is TCPIP running in z/OS?"
   echo "      Did you setup CTCI properly? Is hercules running?"
   echo "      You$red MUST$grn do all of those before this will work" 
else
   # Let's make sure we use the ugliest colors here
   echo "  [+] $HERC_IP is up!$mag You$yel did$cyn it!"
fi

echo $end
