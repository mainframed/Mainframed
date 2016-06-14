#!/bin/bash
#takes a mainframe in s3270 format:
#  [L:]IP/Hostname[:port]
#  the L: means 'use ssl'
$mainframe=$1
s3270 -trace "$mainframe" > /dev/null 2>&1 << EOF
Wait(InputField)
PrintText(html,file,"$mainframe.html")
Disconnect
EOF
