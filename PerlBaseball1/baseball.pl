#!/usr/bin/perl

# Nicholas LaRosa
# CSE 20189

use Player;
use Team;
use Data::Dumper;

if( @ARGV != 1 )
{
	die "Usage: perl baseball.pl <player_file>"
}

$location = $ARGV[0];

open(BASEBALL, $location);
@lines = <BASEBALL>;

%teams = ();		# this hash has team name keys and Team object values

foreach $line (@lines)
{
	my @splits = split(',', $line);	# split line by space
	
	if( scalar (@splits) eq 5 )	# need to make sure we have all fields
	{
		chomp($splits[4]);	# last argument, need to chomp	

		$player = new Player($splits[0], $splits[1], $splits[2], $splits[3], $splits[4]);		# constructs Player object
			
		if( exists $teams{$splits[0]} )	# if team already created
		{
			$teams{$splits[0]}->addPlayer($player);
		}
		else
		{
			$team = new Team();
			$teams{$splits[0]} = $team;			# create team as key value
			$teams{$splits[0]}->addPlayer($player);		# and add player to this team
		}
	}
	else
	{
		print "\nInvalid line (constructor requires five arguments). Skipping...\n";
	}
}

print "\nEnter command or q to exit: ";

print Dumper(\%teams);
#exit 0;

while(my $input = <STDIN>)
{
	chomp($input);

	if( $input eq "q" )
	{
		print "\n";
		last;			# exit user input loop after q entered
	}
	else
	{
		@commands = split(' ', $input);
		my $teamName = "";	

		$command = shift(@commands);		# take off first input word, which is command	

		foreach $argument (@commands)		# for the rest of the words, treat as arguments
		{
			$teamName = $teamName . $argument . " ";
		}

		$teamName =~ s/\s+$//g;			# get rid of trailing whitespace

		if( $command eq "roster" )				# print the roster of given team
		{
			print "\n" . $teamName . " Roster:\n\n";

			if( exists $teams{$teamName} )
			{
				 $teams{$teamName}->getRoster();		# use getRoster to print
			}
			else
			{
				print "\nNo such team exists.\n";
			}
		}
		elsif( $command eq "totalSalary" )			# print the total salary of team
		{
			print "\n" . $teamName . " Total Salary:\n\n";

			if( exists $teams{$teamName} )
			{
				$totalSalary = $teams{$teamName}->getSumOfPlayersSalary();	# use getRoster to return sum
				print '$' . $totalSalary . "\n";
			}
			else
			{
				print "\nNo such team exists.\n";
			}
		}
		else
		{
			print "\nInvalid command. Available commands:\n";
			print "'roster <teamName>' or 'totalSalary <teamName>'.\n";
		}

		print "\nEnter command or q to exit: ";
	}
}


