#!/bin/csh

set FILE = "/afs/nd.edu/coursesp.13/cse/cse20189.01/files/hw5/calc_input.txt"
set count = 1					# keep count of line number

foreach line ("`cat $FILE`")

	set line = `echo "$line" | sed s/\*/x/`	# allow for multiplication with asterisk

	set list = ( $line )			# creates an array out of each line

	if( $#list > 3 ) then			# too many numbers or operations
		echo "Error: Too many numbers or operations on line $count."
	else if( $#list < 3 ) then		# too few numbers or operations
		echo "Error: Too few numbers or operations on line $count." 	
	else
		set first = $list[1]		# we can store two numbers
		set second = $list[2]
		set operator = $list[3]		# and the operator

		switch( $operator )
			case '+':
				set answer = `expr $first \+ $second`
				echo "$first + $second = $answer"
				breaksw
			case '-':
				set answer = `expr $first \- $second`
				echo "$first - $second = $answer"
				breaksw
			case '/':
				if( $second == 0 ) then
					echo "Error: Attempted divide by zero on line $count."
				else
					set answer = `expr $first \/ $second`
					echo "$first / $second = $answer"
				endif
				breaksw
			case 'x':
				set answer = `expr $first \* $second`
				echo "$first * $second = $answer"
				breaksw
			case '%':
				set answer = `expr $first \% $second`
				echo "$first % $second = $answer"
				breaksw
			default:
				echo "Error: At line $count, '$operator' is not a valid operator."
				breaksw
		endsw
	endif		 	

	@ count++			# keep count of lines
end

