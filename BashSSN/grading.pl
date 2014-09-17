#!/usr/bin/perl

# Nicholas LaRosa
# CSE 20189

use Student;
use POSIX;
use Data::Dumper;

if( @ARGV != 1 )
{
	die "Usage: grading.pl <grades_file>\n"
}

$location = $ARGV[0];

open( GRADES, $location );
@lines = <GRADES>;

open( OUTPUT, ">FinalGrades.tex" );

@students;			# array to hold all student objects
$firstAdded = 0;

$numHomeworks = 0;
$numQuizzes = 0;
$numExams = 0;

$weightHomeworks = .50;
$weightQuizzes = .10;
$weightExams = .20;

foreach $line (@lines)
{
	my @splits = split( ',', $line );
	
	if( $splits[0] == "Name" && $firstAdded == 0 )			# perform initial adding of fields
	{
		$numArgs = scalar @splits;	
		shift( @splits );
		%totals = ();		

		foreach $score (@splits)
		{
			my @scoreSplit = split( '-', $score );

			my $ourKey = $scoreSplit[0];
			my $ourTotal = $scoreSplit[1];

			chomp( $ourTotal );

			if( exists $totals{$ourKey} )			# we have already added a similar type grade (Homework, Quiz, etc)
			{
				$totals{$ourKey} = $totals{$ourKey} + $ourTotal; 			
			}
			else						# otherwise, initialize hash key
			{
				$totals{$ourKey} = $ourTotal;
			}
	
			if( $ourKey =~ m/[Hh]omework/ )			# add the homework, quiz, exam totals
			{
				$numHomeworks = $numHomeworks + 1;
			}
			elsif( $ourKey =~ m/[Qq]uiz/ )
			{
				$numQuizzes = $numQuizzes + 1;
			}
			elsif( $ourKey =~ m/[Ee]xam/ )
			{
				$numExams = $numExams + 1;
			}
		}

		$firstAdded = 1;
	}
	elsif( scalar @splits == $numArgs )
	{
		$currentStudent = new Student( $splits[0] );
		shift( @splits );
		my $fieldNumber = 1;

		foreach $score (@splits)
		{
			chomp( $score );

			if( $fieldNumber <= $numHomeworks )					# we are adding homeworks
			{
				$currentStudent->addHomework( $score );
			}
			elsif( $fieldNumber <= $numHomeworks + $numQuizzes )			# we are adding quizzes
			{
				$currentStudent->addQuiz( $score );
			}
			elsif( $fieldNumber <= $numHomeworks + $numQuizzes + $numExams )	# we are adding exams
			{
				$currentStudent->addExam( $score );
			}
		
			$fieldNumber = $fieldNumber + 1;
		}
	
		push( @students, $currentStudent );
	}
	else
	{
		print "Invalid line. Skipping...\n";
	}
}

print OUTPUT "\\documentclass{article}\n";
print OUTPUT "\\title{Homework 12 - Final Grades (Perl)}\n";
print OUTPUT "\\author{Nicholas LaRosa}\n";
print OUTPUT "\\begin{document}\n";
print OUTPUT "\\maketitle\n";
print OUTPUT "\\begin{table}[!htb]\n";
print OUTPUT "\t\\centering\n";
print OUTPUT "\t\\begin{tabular}{ | c | c | c | c | c | c | }\n";
print OUTPUT "\t\\hline\n";
print OUTPUT "\t\\textbf{Student Name} & \\textbf{Homework} & \\textbf{Quiz} & \\textbf{Exam 1} & \\textbf{Exam 2} & \\textbf{Final Grade} \\\\ \\hline\n";

foreach $student (@students)				# we will calculate scores for each student
{
	my $totalScore = 0;

	print OUTPUT "\t" . $student->{_name} . " & ";

	my $homeworkScore = 100*($student->getSumHomeworks())/$totals{Homework};
	$totalScore = $totalScore + ($weightHomeworks*$homeworkScore);	
	$display = ceil( $homeworkScore );	
	print OUTPUT $display . " & ";

	my $quizScore = 100*($student->getSumQuizzes())/$totals{Quiz};
	$totalScore = $totalScore + ($weightQuizzes*$quizScore);
	$display = ceil( $quizScore );
	print OUTPUT $display . " & ";

	my $examNumber = 1;
	
	while( $examNumber <= $student->getNumExams() )
	{
		my $examScore = 100*($student->getExamNumber( $examNumber ))/$totals{"Exam $examNumber"};	
		$totalScore = $totalScore + ($weightExams*$examScore);
		$display = ceil( $examScore );
		print OUTPUT $display . " & ";
		
		$examNumber = $examNumber + 1;
	}

	$totalScore = int( $totalScore + 0.5 );		# now decode final grade percentage

	if( $totalScore <= 100 && $totalScore >= 94 )	
	{
		print OUTPUT "A \\\\\n";
	}
	elsif( $totalScore <= 93 && $totalScore >= 90 )	
	{
		print OUTPUT "A- \\\\\n";
	}
	elsif( $totalScore <= 89 && $totalScore >= 88 )	
	{
		print OUTPUT "B+ \\\\\n";
	}
	elsif( $totalScore <= 87 && $totalScore >= 84 )	
	{
		print OUTPUT "B \\\\\n";
	}
	elsif( $totalScore <= 83 && $totalScore >= 80 )	
	{
		print OUTPUT "B- \\\\\n";
	}
	elsif( $totalScore <= 79 && $totalScore >= 78 )	
	{
		print OUTPUT "C+ \\\\\n";
	}
	elsif( $totalScore <= 77 && $totalScore >= 74 )	
	{
		print OUTPUT "C \\\\\n";
	}
	elsif( $totalScore <= 73 && $totalScore >= 70 )	
	{
		print OUTPUT "C- \\\\\n";
	}
	elsif( $totalScore <= 69 && $totalScore >= 60 )	
	{
		print OUTPUT "D \\\\\n";
	}
	elsif( $totalScore <= 59 && $totalScore >= 0 )	
	{
		print OUTPUT "F \\\\\n";
	}
	
	print OUTPUT "\\hline\n";
}

print OUTPUT "\t\\end{tabular}\n";
print OUTPUT "\t\\caption{This table presents final grades for the class.}\n";
print OUTPUT "\\end{table}\n";
print OUTPUT "\\end{document}\n";

close(GRADES);
close(OUTPUT);

system("pdflatex FinalGrades.tex");
