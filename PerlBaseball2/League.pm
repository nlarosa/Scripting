#!/usr/bin/perl

use Player;
use Team;
use Data::Dumper;
use XML::Simple;

package League;

sub new
{
	my $class = shift;

	my $self = {			# a league will be a hash of teams with string keys
		_teams => {},
		_XML => {}	};
	
	bless( $self, $class );
}

sub getRoster
{
	my $self = shift;
	my $userTeam = shift;		# second argument is the provided team name (as string)

	if (exists $self->{_teams}{$userTeam})
	{
		$self->{_teams}{$userTeam}->getRoster();
	}
	else
	{
		print "No such team exists.\n";
	}
}

sub getTeamSalaryTotal 
{
	my $self = shift;
	my $userTeam = shift;		# second argument is the provided team name (as string)

	if (exists $self->{_teams}{$userTeam})
	{
		my $sum = $self->{_teams}{$userTeam}->getSumOfPlayersSalary();
		print $sum . "\n";
	}
	else
	{
		print "No such team exists.\n";
	}
}

sub addPlayer
{
	my $self = shift;
	my $userTeam = shift;
	my $userPlayer = shift;

	if (exists $self->{_teams}{$userTeam})
	{
		$self->{_teams}{$userTeam}->addPlayerToTeam($userPlayer);
	}
	else
	{
		$team = new Team();
		$self->{_teams}{$userTeam} = $team; 
		$self->{_teams}{$userTeam}->addPlayerToTeam($userPlayer);
	}
}	

sub saveToXML
{
	my $self = shift;
	my $outFile = shift;

	foreach $teamKey (%{$self->{_teams}})					# for every team
	{
		foreach $player (@{$self->{_teams}{$teamKey}{_players}})	# for every player in that team
		{
			$XMLteamName = $player->getTeam();
			$XMLteamName =~ s/\s//g;				# remove all whitespace in team name

			$XMLfirstName = $player->{_firstName};			# and all other strings (just in case)
			$XMLfirstName =~ s/\s//g;
			
			$XMLlastName = $player->{_lastName};
			$XMLlastName =~ s/\s//g;

			$XMLposition = $player->getPosition();
			$XMLposition =~ s/\s//g;

			$XMLplayer = new Player($XMLteamName, $XMLlastName, $XMLfirstName, $player->getSalary(), $XMLposition); 
		
			if (exists $self->{_XML}{$XMLteamName})			# create player with info and add to _XML hash of teams
			{
				$self->{_XML}{$XMLteamName}->addPlayerToTeam($XMLplayer);
			}
			else
			{
				$XMLteam = new Team();
				$self->{_XML}{$XMLteamName} = $XMLteam;
				$self->{_XML}{$XMLteamName}->addPlayerToTeam($XMLplayer);
			}
		}
	}

	open( WRITE, ">$outFile" ) or die "File does not exist\n";
	print "Printing League to $outFile\n";
	
	my $xmlObj = new XML::Simple();
	my $xml = $xmlObj->XMLout($self->{_XML}, NoAttr=>1, RootName=>"League");

	print WRITE $xml;
}

1;
