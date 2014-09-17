#!/usr/bin/perl

# Nicholas LaRosa
# CSE 20189 - Lab 11

use Player;
use Team;
use League;
use Data::Dumper;
use XML::Simple;

if( @ARGV != 1 )
{
	die "Usage: perl baseball.pl <player_file>"
}

$location = $ARGV[0];

open(BASEBALL, $location);
@lines = <BASEBALL>;

$league = new League();		# we will store all players in one league

foreach $line (@lines)
{
	my @splits = split(',', $line); 	# split line by comma

	if( scalar (@splits) eq 5 )		# need to make sure we have all fields	
	{
		chomp($splits[4]);		# last argument, need to chomp

		$player = new Player($splits[0], $splits[1], $splits[2], $splits[3], $splits[4]);		# constructs Player object
                
		$league->addPlayer($splits[0], $player);		# adds current player to team named by string
	}
	else
	{
		print "Invalid player line - must have five fields...\n";
	}
}

#print Dumper($league);

print "\nEnter command or 'stop' to exit: ";

while(my $input = <STDIN>)
{
	chomp($input);
	
	if( $input eq "stop" )
	{
                print "\n";
		last;			# exit user input loop after q entered
	}
	else
	{
		@commands = split(' ', $input);
		my $teamName = "";

		$command = shift(@commands);		# take off first input word, which is command

		if ( $command eq "roster" )					# print the roster of given team
		{
			foreach $argument (@commands)		# for the rest of the words, treat as arguments
			{	
				$teamName = $teamName . $argument . " ";
			}
	
			$teamName =~ s/\s+$//g;			# get rid of trailing whitespace

			print "\n" . $teamName . " Roster:\n\n";

			if( exists $league->{_teams}{$teamName} )
			{
				$league->getRoster($teamName);			# use getRoster to print
			}
			else
			{
				print "\tNo such team exists.\n";
			}
                }
		elsif ( $command eq "totalSalary" )
		{
			foreach $argument (@commands)		# for the rest of the words, treat as arguments
			{	
				$teamName = $teamName . $argument . " ";
			}
	
			$teamName =~ s/\s+$//g;			# get rid of trailing whitespace

			print "\n" . $teamName . " Total Salary:\n\n";
	
			if( exists $league->{_teams}{$teamName} )
			{
				$league->getTeamSalaryTotal($teamName);	
			}
			else
			{
				print "\tNo such team exists.\n";
			}
		}
		elsif ( $command eq "textttsave" )
		{
			my $fileName = shift(@commands);
	
			$league->saveToXML($fileName);
		}
	
		else 
		{
			print "\nInvalid command. Available commands:\n";
			print "'roster <teamName>', 'totalSalary <teamName>', 'textttsave <fileName>'.\n";
		}

		print "\nEnter command or 'stop' to exit: ";
	}
}
