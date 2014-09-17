#!/bin/csh

set dropbox = '/afs/nd.edu/coursesp.13/cse/cse20189.01/dropbox/nlarosa/hw5/dropbox/'
set calc = '/calculator/'
set comments = 'comments'
set arg = '/afs/nd.edu/coursesp.13/cse/cse20189.01/files/hw5/calc_input.txt'

foreach user ("`ls $dropbox`")

	if( -e $dropbox$user$calc$comments ) then		# delete the comments file if it exists
		rm $dropbox$user$calc$comments
	endif

	if( !(-e $dropbox$user$calc) ) then			# if the user's calculator dropbox does not exist
		mkdir $dropbox$user$calc			# create a calculator directory
		touch $dropbox$user$calc$comments		# create the comments file for editing		

		echo "$dropbox$user$calc directory did not exist." >> $dropbox$user$calc$comments
		echo "" >> $dropbox$user$calc$comments
	endif

	if( !(-e $dropbox$user$calc$comments) ) then		# create comments folder if it doesn't exist
		touch $dropbox$user$calc$comments
	endif

	if( !(-e $dropbox$user${calc}calc.csh) ) then		# if the user's calc.csh file does not exist
		echo "No script submission from $user at `date`." >> $dropbox$user$calc$comments
		echo "" >> $dropbox$user$calc$comments
	else
		if( !(-x $dropbox$user${calc}calc.csh) ) then	# if calc.csh exists but is not executable
			echo "Script not executable as submitted: -5 points." >> $dropbox$user$calc$comments
			echo "" >> $dropbox$user$calc$comments
			echo "Run results for $user calculator script:" >> $dropbox$user$calc$comments		
			echo "" >> $dropbox$user$calc$comments
			csh $dropbox$user${calc}calc.csh /afs/nd.edu/coursesp.13/cse/cse20189.01/files/hw5/calc_input.txt >>& $dropbox$user$calc$comments		# run the calculator
			echo "" >> $dropbox$user$calc$comments
		else						# calc.csh is executable						
			echo "Run results for $user calculator script." >> $dropbox$user$calc$comments
			$dropbox$user${calc}calc.csh /afs/nd.edu/coursesp.13/cse/cse20189.01/files/hw5/calc_input.txt >>& $dropbox$user$calc$comments		
# run the calculator
			echo "" >> $dropbox$user$calc$comments
		endif
			
		echo "Testing completed for $user at `date`" >> $dropbox$user$calc$comments
		echo "" >> $dropbox$user$calc$comments
	endif
end

