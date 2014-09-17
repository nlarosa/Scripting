#!/usr/bin/perl

# Nicholas LaRosa, CSE 20189

if( @ARGV != 1 )
{
	die "Usage: perl portCount.pl <message_file>\n";
}

$location = $ARGV[0];			# first argument is location of messages file

open(MESSAGES, $location);
@lines = <MESSAGES>;

%portAttempts = ();			# initialize our port hash

foreach $line (@lines)			# for every line in the messages file
{
	my @splits = split(' ', $line);

	foreach $field (@splits)
	{
		if( $field =~ m/DPT=/ )
		{
			my @portSplit = split('=', $field);
			my $portNumber = @portSplit[1];		# the second term (after equals sign) is the port number
		
			if( exists $portAttempts{$portNumber} )	# key already exists for that specific port number
			{
				$portAttempts{$portNumber} = $portAttempts{$portNumber} + 1;	# add one to the associated value (count)
			}
			else					# key does not exist, not yet found this port
			{
				$portAttempts{$portNumber} = 1;					# creates a new key/value pair (port count)
			}
		}
	}
}	

print "Port Number:	Access Attempts" . "\n";

foreach $portNumber (sort keys %portAttempts)		# print the numerically sorted hash with values
{
	print $portNumber . "		" . $portAttempts{$portNumber} . "\n";		# prints key (port number) and then value (attempt count)
}

