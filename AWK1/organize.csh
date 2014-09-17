#!/bin/csh

# Nicholas LaRosa

set ourPath = './myfiles/'		# this is the directory containing all files

foreach file ("`ls $ourPath`")		# for each file in this directory

	set ext = $file:e		# grab the extension with :e	

	if( $ext == "" ) then		# if there is no extension
		set ext = 'no_ext'
	endif

	if( -d $ourPath$ext ) then			# if a directory with that extension name exists
		mv $ourPath$file $ourPath$ext		# move the file into its respective directory
	else
		mkdir $ourPath$ext			# create a directory for that extension
		mv $ourPath$file $ourPath$ext		# and move the file there
	endif
end

