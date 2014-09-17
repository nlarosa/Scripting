# Nicholas LaRosa
# CSE 20189

package Player;

sub new			# constructor - arguments 1. team name, 2. last name, 3. first name, 4. salary, 5. position		
{
	my $class = shift;	# get class type constructed
	my $self = {
		_team => shift,				# first argument - team name
		_lastName => shift,			# second/third arguments - last first name
		_firstName => shift,
		_salary => shift,
		_position => shift };

	#print "Team name: $self->{_team}\n";
	#print "Full name: $self->{_fullName}\n";
	#print "Salary: $self->{_salary}\n";
	#print "Position: $self->{_position}\n";

	bless($self, $class);	# changes self from hash reference to Player reference
	return $self;		# return reference to Player instance
}

sub getSalary
{
	my( $self ) = @_;		# gets object name as argument
	return $self->{_salary};	# returns value of key _salary
}

sub getFullName
{
	my( $self ) = @_;						# gets object name as argument
	return ($self->{_firstName} . " " . $self->{_lastName});	# returns value of key _fullName
}

sub getPosition
{
	my( $self ) = @_;		# gets object name as argument
	return $self->{_position};	# returns value of key _position
}

sub getTeam
{
	my( $self ) = @_;		# gets object name as argument
	return $self->{_team};		# returns value of key _team
}

1;		# return true value
