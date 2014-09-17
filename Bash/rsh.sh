#!/bin/bash

introduction()		# Displays the command options
{
	clear
	echo ""
	echo "Command Action:		Command number:"
	echo "Disk Free		1"
	echo "Disk Usage		2"
	echo "List Files		3"
	echo "Process Status		4"
	echo "Examine Volume		5"
	echo "Shell Escape		6"
	echo "Current Date		7"
	echo "Exit			8"
}

prompt()		# Prints text relating to new command choice
{
	echo ""
	echo -n "Choose your command: "
}

Disk_Free()		# requires one prompt - filespec
{
	echo ""
	echo -n "Please provide the filespec of interest: " 	
	read fileSpec
	echo ""
	echo "Command: df -k $fileSpec"
	echo "Command output: "
	echo ""
	df -k $fileSpec
}

Disk_Usage()		# requires one prompt - filespec
{
	echo ""
	echo -n "Please provide the filespec of interest: "
	read fileSpec
	echo ""
	echo "Command: du -s -k $fileSpec"
	echo "Command output: "
	echo ""
	du -s -k $fileSpec
}

List_Files()		# no extra prompt necessary
{
	echo ""
	echo "Command: ls -F ."
	echo "Command output: "
	echo ""
	ls -F .
}

Process_Status()	# no extra prompt necessary
{
	echo ""
	echo "Command: top"
	echo "Command output: "
	echo ""
	top
}

Examine_Volume()	# requires one prompt - afsid
{
	echo ""
	echo -n "Please provide the AFS ID of interest: "
	read afsID
	echo ""
	echo "Command: vos examine $USER.$afsID"
	echo "Command output: "
	echo ""
	vos examine $USER.$afsID
}

Shell_Escape()		# no extra prompt necessary
{	
	echo ""
	echo "Command: /bin/bash"
	echo "Command output: "
	echo ""
	/bin/bash
}

Current_Date()		# no extra prompt necessary
{
	echo ""
	echo "Command: date +\"%a %b %Y %r\""
	echo "Command output:"
	echo ""
	command="date +\"%a %b %Y %r\""			# store command as string
	eval $command	
}

Exit_rsh()		# exiting function
{
	echo ""
	echo "Exiting..."
	echo ""
	exit 0		# we have exited successfully 
}

control_c()		# if user attempts to call CTRL^C
{
	echo ""
	echo "Select option 8 to exit. Please try again." 
	echo ""
}

trap control_c SIGINT	# traps the CTRL^C calls, notifies user of command

introduction		# displays menu of commands

while true
do 
	prompt
	read input;

	case $input in
		1)	Disk_Free
			;;
		2)	Disk_Usage
			;;
		3)	List_Files
			;;
		4)	Process_Status
			;;
		5)	Examine_Volume
			;;
		6)	Shell_Escape
			;;
		7)	Current_Date
			;;
		8)	Exit_rsh
			;;
		*)	echo "Not a valid command. Please try again."		# if anything else is entered by the user
			continue
			;;
	esac
done

