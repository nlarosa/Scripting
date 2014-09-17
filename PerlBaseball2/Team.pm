# Nicholas LaRosa
# CSE 20189

use Player;

package Team;

sub new
{
	my $class = shift;

	my $self = {			# only data member will be an array of Player instances
		_players => [] };		

	bless( $self, $class );
	return $self;
}

sub getSumOfPlayersSalary
{
	my( $self ) = shift;		# get reference to current Team instance
	my $runningSum = 0;

	foreach $player (@{$self->{_players}})				# for every player on roster
	{
		$runningSum = $runningSum + ($player->getSalary());	# add getSalary value to sum
	}

	return $runningSum;
}

sub getRoster
{
	my( $self ) = shift;
	
	foreach $player (@{$self->{_players}})							# for every player on roster
	{	
		print ($player->getFullName() . " -> " . $player->getPosition() . "\n");	# print the key/value pair
	}

	return $self;
}

sub addPlayerToTeam
{
	my $self = shift;
	my $newPlayer = shift;
	
	push( @{$self->{_players}}, $newPlayer ); 	# add Player object to end of Team data member array
	
	return $self;
}

1;
