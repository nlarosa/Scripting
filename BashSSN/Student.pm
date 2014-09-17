#!/usr/bin/perl

# Nicholas LaRosa
# CSE 20189

package Student;

sub new				# constructor - takes student name as argument
{
	my $class = shift;
	my $self = {
		_name => shift,
		_homeworks => [],
		_quizzes => [],
		_exams => [] };
	
	bless( $self, $class );
	return $self;
}

sub addHomework
{
	my $self = shift;
	my $homeworkScore = shift;

	push( @{$self->{_homeworks}}, $homeworkScore );

	return $self;
}

sub addQuiz
{
	my $self = shift;
	my $quizScore = shift;

	push( @{$self->{_quizzes}}, $quizScore );
	
	return $self;
}

sub addExam
{
	my $self = shift;
	my $examScore = shift;

	push( @{$self->{_exams}}, $examScore );
	
	return $self;
}

sub getSumHomeworks
{
	my $self = shift;
	my $runningSum = 0;

	foreach $homework (@{$self->{_homeworks}})
	{
		$runningSum = $runningSum + $homework;
	}

	return $runningSum;
}

sub getSumQuizzes
{
	my $self = shift;
	my $runningSum = 0;

	foreach $quiz (@{$self->{_quizzes}})
	{
		$runningSum = $runningSum + $quiz;
	}

	return $runningSum;
}

sub getNumExams
{
	my $self = shift;
	
	return scalar @{$self->{_exams}};
}

sub getExamNumber
{
	my $self = shift;
	my $number = shift;

	return @{$self->{_exams}}[ $number - 1 ];
}

1;
