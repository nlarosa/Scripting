#!/bin/awk -f
BEGIN {
	FS = ":";	# a:b:c, so $1 = a, $2 = b, $3 = c
	x1 = 0;		# roots x1 and x2
	x2 = 0;
}
{
if( $2^2 - 4*$1*$3 >= 0 ){
	x1 = (-$2 + sqrt( $2^2 - 4*$1*$3 )) / ( 2*$1 );
	x2 = (-$2 - sqrt( $2^2 - 4*$1*$3 )) / ( 2*$1 );
	int "(" x1 ",0):(" x2 ",0)";
}
else{
	print "NaN:NaN";
}
}
