#!/usr/bin/python
print "[i] Super cheesy script to make PDS's, cause fuck ISPF, thats why "
print "[i] Uses FTP to create PDS. Assumes port 21"
#print "[~] mkdir pds_name to create file                                                        "
#print "[~] puts an empty file in the pds (or member you pedantic)                               "
print "[!] takes three arguments: hostname username password pds_name"
print "[!] i.e. ./create_pds.py emc plague secret HAXORS "
print "[!] or ./create_pds.py 192.168.0.7 margo god amazing
print "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n"

debug = False

import ftplib
import cStringIO
import sys

print "hostname", sys.argv[1]
hostname = sys.argv[1]
print "usnermae", sys.argv[2]
username = sys.argv[2]
print "password ********" #LOL
password = sys.argv[3]
print "filename", sys.argv[4]
filename = sys.argv[4]
if len(sys.argv) >= 6:
	if sys.argv[5] == "yes": debug = True

ftp = ftplib.FTP(hostname)

if debug: print ftp.getwelcome()
print "\n weeeeeee\n"
ftp.login(username, password)
#print ftp.sendcmd('site lr=32000 blk=32000 directory=25 primary=1500 secondary=250 cy')
print "[+] making pds", filename
d = ftp.sendcmd('mkd '+filename)
if debug: print d
d = ftp.cwd(filename)
if debug: print d
voidfile = cStringIO.StringIO('')
print "[+] creating EMPTY member in pds", filename

d = ftp.storbinary('STOR EMPTY', voidfile)
if debug: print d

ftp.close()
voidfile.close()
